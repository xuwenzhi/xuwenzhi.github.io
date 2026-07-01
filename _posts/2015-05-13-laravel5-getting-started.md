---
layout: post
title: "Laravel5入门教程"
tags: php laravel
---

提前声明:

此篇文章只是对laravel5的入门，伴随着敝人的学习laravel5的过程一点一点堆出来的，基本上是对于我们开发项目有用的部分，可以说这些内容全部源自laravel的中文官网。如果想看高级特性，可以看laravel5的官方文档。

准备工作:

1.安装composer 因为laravel可以通过composer安装，但也不是必须的，这点可以略过。

2.安装类似于Wamp或者XAMPP这样的php开发环境。

3.Laravel对环境的要求 : php5.4以上、Mcrypt扩展、Openssl扩展、MbString扩展和Tokenizer扩展。

Note : 可以看到Laver对于php环境的要求还是很高的， 个人推荐不用Wamp这个开发环境，最好是能够安装XAMPP,其实只要能够达到Laravel的环境要求即可。

一、安装Laravel运行环境

1.composer的安装网上资料很多，这里就不再赘述。

2.XAMPP环境的安装，这里也不再赘述了。

3.使用Laravel除了可以通过composer这样的工具之外，还可以通过下载已编译好的laravel包来运行，直接到https://github.com/overtrue/latest-laravel下载编译包即可直接拿来用，这样就不需要使用composer了，不过如果日后需要进行包管理的话，可以再安装composer。

打开浏览器，执行http://localhost/laravel/public/index.php，可以看到效果，index.php也就是Laravel的入口文件。

二、路由机制

Laravel的路由机制非常灵活可用，不仅可以直接在路由中处理UI逻辑即可以直接调用视图view，还可以指定控制器来处理复杂逻辑，赞！主要的路由配置在app/routes.php中，下面列出常用的路由定义规则

①get

```
Route::get('/', function()
    {
        return 'Hello World';
    });

```

请求方式: http://localhost/laravel/public/index.php

②post

```
Route::post('foo/bar', function()
    {
        return 'Hello World';
    });

```

请求方式: http://localhost/laravel/public/index.php/foo/bar

③响应任何请求

```
Route::any('foo', function()
{
    return 'Hello World';
});

```

请求方式: http://localhost/laravel/public/index.php/foo

那么路由中带有参数如何处理？比如经常可以看到的index.php?id=22

④带有参数的路由

```
Route::get('user/{id}', function($id)
{
    return 'User '.$id;
});

```

请求方式: http://localhost/laravel/public/index.php/user/22

⑤参数带有默认值路由

```
Route::get('user/{name?}', function($name = 'John')
{
    return $name;
});

```

请求方式: http://localhost/laravel/public/index.php/user/azxuwen 后面的/azxuwen可有可没有，如果没有$name默认为John

⑥带有正则表达式约束的路由

```
Route::get('user/{name}', function($name)
{
    //
})
->where('name', '[A-Za-z]+');

```

请求方式: http://localhost/laravel/public/index.php/user/azxuwen 后面的azxuwen 只能是由字母组成的字符串。

上面只是一些基本的路由定义方法，当然Laravel对路由的支持不止于此，Laravel提供了对路由的过滤器，在app/filter.php中，下面是一个简单的例子。

在app/filter.php中添加，old过滤器，如果路由参数age如果小于200，则会执行跳转。

```
Route::filter('old', function()
{
    if (Input::get('age') < 200)
    {
        return Redirect::to('home');
    }
});

```

然后在app/routes.php中使用过滤器old

```
Route::get('user', array('before' => 'old', function()
{
    return 'You are over 200 years old!';
}));

```

请求方式: http://localhost/laravel/public/index.php/user/180 在请求时，后面的180就会去执行过滤器。

三、中间件

普通的框架来讲，一个请求过来会首先经过路由，然后由路由分发到controller，这个中间件是laravel提供在路由和控制器中间的一个基础检查工具，在这里可以做一些预先的检查工作，比如用户验证之类的工作。

laravel的中间件应用的也是很简单，在laravel5中，/app/Http/Middleware目录中存放着中间件的类，laravel预先提供了Authenticate等中间件。

下面，我们自己定义中间件OldMiddleware，该中间件做到age如果大于200就执行跳转到首页的功能。

1.打开cmd，进入项目根目录，执行命令。

```
php artisan make:middleware OldMiddleware

```

如果创建成功，会提示Middleware created successfully.

2.打开IDE，找到OldMiddleware，修改function handle()

```
public function handle($request, Closure $next)
    {
        $age = 201;
        if ($age > 200)
        {
            return redirect('/');
        }

        return $next($request);
    }

```

3.找到app目录下的Kernel.php，找到静态数组项 $routeMiddleware，在其中添加键值，填好后是这样的。这里配置的目的是:将中间件应用于确定的路由

```
protected $routeMiddleware = [
        'auth' => 'App\Http\Middleware\Authenticate',
        'auth.basic' => 'Illuminate\Auth\Middleware\AuthenticateWithBasicAuth',
        'guest' => 'App\Http\Middleware\RedirectIfAuthenticated',
        'old' => 'App\Http\Middleware\OldMiddleware'
    ];

```

4.找到routes.php，添加一个使用刚刚建立的中间件old项。

```
Route::get('/user/{id}', ['middleware' => 'old', function(){
    return '某用户';
}]);

```

在浏览器中验证，输入http://localhost/laravel/public/index.php/user/222，并执行

会发现，浏览器跳转到了首页 http://localhost/laravel/public/index.php

那么能不能将定义的中间件应用到所有路由呢？肯定是可以的，就需要将中间件定义到全局的配置中去，打开Kernel.php，找到静态数组$middleware，添加一个键值即可。

其实laravel中间件的功能还是很多的，这里只是冰山一角。

四、控制器

laravel的控制器可以分为 基础控制器、控制器中间件、隐式控制器、RestFul资源控制器、依赖注入和控制器和路由缓存。下面演示如何使用基础控制器。

1.在routes.php中新建路由，此路由也就是说将交给UserController类下的getUser()来接管

```
Route::get('user/{id}', 'UserController@getUser');

```

2.因为laravel的控制器放在app/Http/controllers/下，在此目录下新建类UserController.php，并写入以下代码

```
<?php
namespace App\Http\Controllers;
use App\Http\Middleware\OldMiddleware;
use Illuminate\Http\Request;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Foundation\Validation\ValidatesRequests;

class UserController extends Controller{
    public function getUser($id){
        echo "Hello " . $id;
    }
}

```

打开浏览器输入: http://localhost/laravel/public/index.php/user/33<br ?–>

那么如果没错的话，会看到               Hello 33

看到其中那么多的命名空间，我想一般人都已经疯了，其实我也疯了，慢慢学习慢慢熟悉它们吧。

五、请求

也就是处理客户端浏览器的form表单数据，Laravel使用了Symfony的Request，所以这里需要使用这个东东，下面做一个简单的表单提交功能，比如登录。

1.新建两个路由，一个用于处理表单页面的显示，一个用于处理表单

```
//登录页表单
Route::get('form', ['uses' => 'UserController@form', 'as' => 'name']);
//处理表单登录的action
Route::post('signup', 'UserController@signup');

```

2.在UserController.php中新建两个函数，form()，用于显示登录页，发现view，所以接下来需要在resources/views中新建form.blade.php文件

```
public function form(){
    return response()->view('form')->header('Content-Type', 'text/html');
}

public function signup(Request $request){
    $input = $request->all();
    var_dump($input);
}

```

3.新建form.blade.php文件，注意，其中添加了一行****，因为Laravel默认会为我们检车token，防止倒链攻击

```
<form action="{{{ URL::action('UserController@signup') }}}" method="post">
        <input name="username" type="text" />
<input name="password" type="password" />
<input name="_token" type="hidden" value="{{ csrf_token() }}" />
        <input type="submit" value="提交" />
    </form>

```

4.打开浏览器，输入http://localhost/laravel/public/index.php/form，可以看到登录表单，输入一些内容，点击提交，则会跳转到http://localhost/laravel/public/index.php/signup，在这里就会看到表单提交数据

Note:这里只是一个简单的表单提交页面，Laravel提供的响应机制还有其他功能，比如取得cookie，处理文件上传。

六、响应

说白了也就是返回给用户的结果。

1.由路由直接返回一段字符串，前面说的laravel的路由中一项牛逼的东东是可以直接构造响应数据，下面的路由构造方式是当用户访问出错的时候，直接在页面中打印出“您访问的页面出错”

```
Route::get('/error', function()
{
    return '您访问的页面出错';
});

```

请求方式:http://localhost/laravel/public/index.php/error

2.由路由直接调用一个视图文件，然后返回，现在说一下，默认的视图文件放在resources/views目录下，由于laravel使用blade模板引擎，所以首先在resources/views目录下新建一个error.blade.php文件，里面写入”您访问的页面出错“，这个就是模板文件，现在定义如下路由，

```
Route::get('/error', function(){
    return View::make('error');
});

```

请求方式:http://localhost/laravel/public/index.php/error 会发现跟上面一样的效果

3.自定义响应，使用Symfony的response方法，由于laravel使用了Symfony的request和response机制，所以可以通过laravel实现自定义的响应页面，并且可以定义页面Mine类型，还是新建路由

```
Route::get('/error', 'UserController@error');

```

然后在UserController.php中新建error方法

```
public function error(){
        return (new Response('您访问的页面出错', 200))
              ->header('Content-Type', 'text/html');
    }

```

Note: 还需要再UserController.php上部引入Response命名空间

```
use Illuminate\Http\Response;

```

请求方式:http://localhost/laravel/public/index.php/error 还是会发现跟上面一样的效果

另外，这里还是可以使用视图文件的方式来响应，而在这只是以简单的字符串的方式返回给了浏览器，那么如何使用视图？

修改上面的error()方法

```
public function error(){
        return response()->view('error')->header('Content-Type', 'text/html');
    }

```

并且还是使用上面在resources/views下建立的error.blade.php文件

请求方式:http://localhost/laravel/public/index.php/error 还是会发现跟上面一样的效果

所以laravel的响应机制真的是非常灵活，还有其他功能，比如

附加cookie到浏览器中

重定向

返回不同格式的响应，比如json，jsonp等等

七、视图

之前说过，视图文件放在resources/views文件夹下，也就是一些HTML代码和由控制器分配给视图文件的一些变量，下面来做一个简单的例子。

1.新建一个路由

```
Route::get('testView', 'UserController@testView');

```

2.在UserController.php中新建一个函数，会看到这里我们向模板文件分配了一个$data的数组变量

```
public function testView(){
    $data = array(
        'name' => 'Laravel'
    );
    return view('testview', $data);
}

```

3.新建一个视图文件，testview.blade.php，由控制器分配过来的$data,可以通过”$键名”的方式来输出

```
Hello <?php echo $name;?> !

```

请求方式:http://localhost/laravel/public/index.php/testView ，即可看到 “Hello Laravel !”

所以一个基本的视图使用就OK了，除了这些你可能还有些疑问，那JS、Css文件该如何搞，一般的搞法也就是将这些前端库文件放在resources文件夹内，统一处理前端资源，另外视图还有一个高级特性，就是视图组件，使用视图组件可以在渲染页面之前对需要处理的内容预先处理到模板中，这只是我的浅显理解，需要了解的同学可以到官网查看这部分内容。

八、数据库

暂时不知道laravel操作数据库有多牛逼，可以查看config目录下的database.php文件，这里是数据库的配置文件，laravel支持4种数据库，包括Mysql，Postgres，SQLLite和SqlServer。在database.php中找到connections变量，这里定义了数据库的连接信息，找到Mysql那里，将数据库按照你的实际情况补全，我的是这样的

```
'mysql' => [
         'driver'    => 'mysql',
         'host'      => 'localhost',
         'database'  => 'ishare_school',
         'username'  => 'root',
         'password'  => '',
         'charset'   => 'utf8',
         'collation' => 'utf8_unicode_ci',
         'prefix'    => '',
          'strict'    => false,
],

```

好，现在在数据库中建立一个user表，添加几条记录，现在来一个现场查询数据

1.定义路由

```
Route::get('user/{id}', 'UserController@getUser');

```

2.在UserController.php中完成getUser方法

```
public function getUser($id){
        $sql = "select * from user where id = $id";
        $results = DB::select($sql);
        var_dump($results);
    }

```

3.稍等片刻，在这里使用了DB这个类，然而我们还没有将它引进来个人觉得，laravel的命名空间这个概念的确挺超前的，不过作为新手，的确也不知道某些类在哪个命名空间下，这时候可以通过选择一个不错的IDE来学习，比如PHPstorm，当你输入use DB的时候，可能它就帮你补全了，这一点还是很棒的，所以我们需要引入DB所在的命名空间。

```
use Illuminate\Support\Facades\DB;

```

请求方式:http://localhost/laravel/public/index.php/user/1 可以发现，user表中id为1的那条数据已经被取出来了。

说点稍微高级的

读写分离 ：

在database.php中connections那部分，可以将读写分离开来，例如下面的配置，在配置中会发现加了两个键read和write，可以通过配置不同的host来做到读写分离，或主从分离。

```
'mysql' => [
    'read' => [
        'host' => '192.168.1.1',
    ],
    'write' => [
        'host' => '196.168.1.2'
    ],
    'driver'    => 'mysql',
    'database'  => 'database',
    'username'  => 'root',
    'password'  => '',
    'charset'   => 'utf8',
    'collation' => 'utf8_unicode_ci',
    'prefix'    => '',
],

```

事务：

Laravel对于事务的处理上也是很方面和灵活，提供了两种提交事务的方法

```
DB::transaction(function()
{
    DB::table('users')->update(['votes' => 1]);

    DB::table('posts')->delete();
});

```

和

```
//开始事务
DB::beginTransaction();
//回滚
DB::rollback();
//提交事务
DB::commit();

```

查询构造器：

Laravel专门为SQL建立了构造器，说白了也就是定义了SQL的规范，通过一系列的链式操作达到查询的目的，从此再也不需要写sql语句了。

下面来将上面使用纯sql实现的查询进行修改，找到刚刚的getUser()方法，对其进行修改，这种写法同样可以达到刚刚的效果。

```
public function getUser($id){
        $user = DB::table('user')->where(array('id'=> 1))->first();
        var_dump($user);
    }

```

并且除了上面可以将查询条件放在where()函数外，还支持其他的比如 or ，between，聚合函数的使用甚至是join等操作，所以使用构造器完全可以达到业务逻辑需求。

另外，也支持修改、更新和删除操作。

Note:上面基本的SQL操作完全可以达到基本需求了，如果想用的更爽，Laravel还支持ORM数据绑定、以及数据迁移工作和Redis缓存等的支持，想要了解这些更高级的特性，可以查看Laravel5的官方文档。

Laravel5入门教程
