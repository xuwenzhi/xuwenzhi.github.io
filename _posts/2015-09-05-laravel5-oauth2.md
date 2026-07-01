---
layout: post
title: "Laravel5 整合 Oauth2.0"
tags: php laravel oauth
---

**Laravel5：**一款享誉国内外的PHP框架。

**Oauth2.0 :** 一款耳熟能详的作为令牌验证机制的开源软件。

附:如果你对Oauth的工作原理还不熟悉的话，看看阮老师的这篇文章[理解OAuth 2.0](http://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html)，我们接下来将实现的是Oauth中的密码模式。

**为什么要将Oauth2.0整合到Laravel5.1中呢？**

主要的动机是我需要做一个Android客户端，这必然涉及到与服务器的交互，虽然自己去完成Oauth的Token验证功能并不是太难，但是既然人家Oauth已经这么成熟了，何苦去自己写呢？另外，因为我的Web项目就是使用Laravel5开发的，所以也就出现了我现在需要将Oauth融入到我的Laravel框架中。

**如何实现？**

其实如果单纯的将Oauth2.0整合到Laravel中其实并没有直接的途径，比如框架千千万万，而Oauth也并不会为每一种框架都准备使用教程对吧？所以只能去github上找找出路。

好在github上真的有解决方案，当然方案还不止一种，但我以我的亲身经历证明，这一款比较牛逼，提前声明的是这一款是使用Laravel5内置的Middleware来实现的，当然我认为这样的话会更加灵活。

解决方案在此 ： [https://bshaffer.github.io/oauth2-server-php-docs/cookbook/laravel/](https://bshaffer.github.io/oauth2-server-php-docs/cookbook/laravel/)

>

虽然作者的教程已经很细致了，但还是墙裂推荐你和我一起往下走~

**1.使用composer安装oauth2-server-php**

```
composer require bshaffer/oauth2-server-php
composer require bshaffer/oauth2-server-httpfoundation-bridge

```

由于国外镜像被墙，国内镜像还不稳定，据我所知国内现在有两个镜像可以用，如果一个不行用另一个。

**2.创建Oauth相关的表迁移**

在项目根目录下执行

```
php artisan db:migrate create_oauth_tables

```

执行完该命令后，会在database/migrations/目录下生成一个以当前日期为开头的以create_oauth_tables结尾的.php文件，打开它，输入以下代码，并保存。

```
<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateOauthTables extends Migration {

    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
    $schema = <<<SCHEMA
CREATE TABLE oauth_clients (client_id VARCHAR(80) NOT NULL, client_secret VARCHAR(80) NOT NULL, redirect_uri VARCHAR(2000) NOT NULL, grant_types VARCHAR(80), scope VARCHAR(100), user_id VARCHAR(80), CONSTRAINT client_id_pk PRIMARY KEY (client_id));
CREATE TABLE oauth_access_tokens (access_token VARCHAR(40) NOT NULL, client_id VARCHAR(80) NOT NULL, user_id VARCHAR(255), expires TIMESTAMP NOT NULL, scope VARCHAR(2000), CONSTRAINT access_token_pk PRIMARY KEY (access_token));
CREATE TABLE oauth_authorization_codes (authorization_code VARCHAR(40) NOT NULL, client_id VARCHAR(80) NOT NULL, user_id VARCHAR(255), redirect_uri VARCHAR(2000), expires TIMESTAMP NOT NULL, scope VARCHAR(2000), CONSTRAINT auth_code_pk PRIMARY KEY (authorization_code));
CREATE TABLE oauth_refresh_tokens (refresh_token VARCHAR(40) NOT NULL, client_id VARCHAR(80) NOT NULL, user_id VARCHAR(255), expires TIMESTAMP NOT NULL, scope VARCHAR(2000), CONSTRAINT refresh_token_pk PRIMARY KEY (refresh_token));
CREATE TABLE oauth_users (username VARCHAR(255) NOT NULL, password VARCHAR(2000), first_name VARCHAR(255), last_name VARCHAR(255), CONSTRAINT username_pk PRIMARY KEY (username));
CREATE TABLE oauth_scopes (scope TEXT, is_default BOOLEAN);
CREATE TABLE oauth_jwt (client_id VARCHAR(80) NOT NULL, subject VARCHAR(80), public_key VARCHAR(2000), CONSTRAINT client_id_pk PRIMARY KEY (client_id));
SCHEMA;

        foreach (explode("\n", $schema) as $statement) {
            DB::statement($statement);
        }
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
        DB::statement('DROP TABLE oauth_clients, oauth_access_tokens, oauth_authorization_codes, oauth_refresh_tokens, oauth_users, oauth_scopes, oauth_jwt');
    }

}

```

保存后，terminal切换到项目根目录，执行如下命令。

```
php artisan migrate

```

执行完命令后会发现，数据库中会出现好多oauth开头的数据表。

**3.新建seeds**

在database/seeds/目录下新建两个文件，分别命名为OAuthClientsSeeder.php 和 OAuthUsersSeeder.php文件，写入如下代码

OAuthClientsSeeder.php

```
<?php
use Illuminate\Database\Seeder;
class OAuthClientsSeeder extends Seeder
{
    public function run()
    {
        DB::table('oauth_clients')->insert(array(
            'client_id' => "testclient",
            'client_secret' => "testpass",
            'redirect_uri' => "http://fake/",
        ));
    }
}

```

OAuthUsersSeeder.php

```
<?php
use Illuminate\Database\Seeder;
class OAuthUsersSeeder extends Seeder
{
    public function run()
    {
        DB::table('oauth_users')->insert(array(
            'username' => "bshaffer",
            'password' => sha1("brent123"),
            'first_name' => "Brent",
            'last_name' => "Shaffer",
        ));
    }
}

```

保存退出后，切换到项目根目录，执行以下命令，自动加载下composer的配置

```
composer dump-autoload

```

再执行下面这条命令，将刚刚新建的两个种子OAuthClientsSeeder.php 和 OAuthUsersSeeder.php插入一些数据进入数据库

```
php artisan db:seed

```

这是会发现oauth_users和oauth_clients这两个表各插入了一条数据。

**4.routeMiddleware配置**

打开app/Http/Kernel.php，将’App\Http\Middleware\VerifyCsrfToken’,这一行注释，原因在于客户端是无状态的，也没有HTML表单中的_token变量，所以需要禁用掉Csrf的验证。

在$routeMiddleware增加一行，’oauth’=> ‘App\Http\Middleware\OauthMiddleware’,因为本教程实现的就是希望能够在request和controller中间加一层middleware来实现Token的验证机制，所以当我们新增了这一行之后，下面还需要添加OauthMiddleware这个中间件才行。

修改后的Kernel.php文件为：

```
<?php namespace App\Http;

use Illuminate\Foundation\Http\Kernel as HttpKernel;

class Kernel extends HttpKernel {

    /**
     * The application's global HTTP middleware stack.
     *
     * @var array
     */
    protected $middleware = [
        'Illuminate\Foundation\Http\Middleware\CheckForMaintenanceMode',
        'Illuminate\Cookie\Middleware\EncryptCookies',
        'Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse',
        'Illuminate\Session\Middleware\StartSession',
        'Illuminate\View\Middleware\ShareErrorsFromSession',
        //'App\Http\Middleware\VerifyCsrfToken',
    ];

    /**
     * The application's route middleware.
     *
     * @var array
     */
    protected $routeMiddleware = [
        'auth' => 'App\Http\Middleware\Authenticate',
        'auth.basic' => 'Illuminate\Auth\Middleware\AuthenticateWithBasicAuth',
        'guest' => 'App\Http\Middleware\RedirectIfAuthenticated',
        'csrf' => 'App\Http\Middleware\VerifyCsrfToken',
        'oauth'=> 'App\Http\Middleware\OauthMiddleware',
    ];

}

```

添加中间件 OauthMiddleware

在app/Http/Middleware目录下新建OauthMiddleware.php文件，保存以下代码。

```
<?php namespace App\Http\Middleware;
use Closure;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Log;
use OAuth2\HttpFoundationBridge\Request as OAuthRequest;

class OauthMiddleware{
    public function handle($request, Closure $next){
        if(!$request->input('access_token')){
            return response( 'Token not found', 422);
        }
        $req = \Symfony\Component\HttpFoundation\Request::createFromGlobals();
        $bridgeRequest = OAuthRequest::createFromRequest($req);
        $bridgeResponse = new \OAuth2\HttpFoundationBridge\Response();

        if(!$token = App::make('oauth2')->getAccessTokenData($bridgeRequest, $bridgeResponse)){
            $response = App::make('oauth2')->getResponse();
            if($response -> getParameter('error') == 'expired_token'){
                return response('The access token provided has expired', 401);
            }
            return response('Invalid Token.', 422);
        } else {
            $request['user_id'] = $token['user_id'];
        }
        return $next($request);
    }
}

```

**5.route路由配置**

打开app.Http/routes.php中新增如下代码，注意更改Pdo连接数据库的username和password

```
App::singleton('oauth2', function() {
     $storage = new OAuth2\Storage\Pdo(array(
        'dsn' => 'mysql:dbname=ishare_school;host=localhost', 'username' => 'root', 'password' => env('DB_PASSWORD', '')));
     $server = new OAuth2\Server($storage);
     $server->addGrantType(new OAuth2\GrantType\ClientCredentials($storage));
     $server->addGrantType(new OAuth2\GrantType\UserCredentials($storage));
     return $server;
});
Route::get('oauth/token', function()
{
    $bridgedRequest  = OAuth2\HttpFoundationBridge\Request::createFromRequest(Request::instance());
    $bridgedResponse = new OAuth2\HttpFoundationBridge\Response();

    $bridgedResponse = App::make('oauth2')->handleTokenRequest($bridgedRequest, $bridgedResponse);
    return $bridgedResponse;
});

```

>

目前为止，已经安装完毕，接下来让我们看看怎么使用

**1.获取Token**

  请求服务器，路由为oauth/token来获得Token，来个实际例子，如果你安装了POSTMAN的话，就可以这样来做请求，或者也可以通过别的方式

按照如图类似的请求，则会得到类似如下的结果

**2.有些API需要验证Token，有些API不需要验证Token怎么办？**

别忘了我们新增了一个middleware啊。

不需要验证Token的路由怎么写？

[cc lang=”php” theme=”twitlight” width=”100%” height=”700″ lines=”40″ noborder=”true”]

Route::post(‘veirfycode’, ‘Api\UserController@veirfyCode’);

[/cc]

需要验证Token的路由怎么写？

```
Route::post('addpasswd'  , ['middleware' => 'oauth', 'uses'=>'Api\UserController@addPassword']);

```

>

这个开源库有什么缺点

1.毕竟这个Oauth2.0是个国外的产品，有许多提示信息还是英文，需要做的可能是要更改oauth2-server-php的源码

2.除了语言层面，还有一点是Oauth2.0的验证方式并非很适合已经有一定用户的情况，所以需要将网站已有用户的数据同步到oauth_access等数据表中才可以。

若转载，请注明出处，谢谢配合。

Laravel5 整合 Oauth2.0
