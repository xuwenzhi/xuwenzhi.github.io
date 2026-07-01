---
layout: post
title: "Laravel5 发送邮件"
tags: php laravel
---

Laravel基础组件里面为我们提供了发送邮件的功能，下面将介绍如何使用Laravel内置的Mail库来发送邮件，这里使用网易163邮件服务器发送。

一个简单的当用户注册后，发送验证邮件的功能。

1.邮件所在的配置文件在app/mail.php中

```
'host' => 'smtp.163.com',
'port' => 25,
'from' => array('address' => 'XXXXXX@163.com', 'name' => '邮件标题'),
'username' => 'XXXXXX@163.com',
'password' => 'XXXXX',

```

2.添加路由

```
Route::get('/sendMail', 'UserController@sendMail');

```

3.在UserController.php中添加sendMail函数

```
public function sendMail(){
        $data = ['email'=>'358350782@qq.com', 'name'=>'徐文志','uid'=>1, 'activationcode'=>'464343'];
        Mail::send('activemail', $data, function($message) use($data)
        {
            $message->to('358350782@qq.com', '徐文志')->subject('欢迎注册我们的网站，请激活您的账号！');
        });
    }

```

添加命名空间

```
use Illuminate\Support\Facades\Mail;

```

Note:其中send()的第一个参数是构造的邮件内容的视图文件，也就是肯定要在resource/views/下存在一个activemail.blade.php文件。

4.新建视图文件activemail.blade.php文件

```
<!doctype html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
  </head>
<body>
  <a href="{{ URL('active?uid='.$uid.'&activationcode='.$activationcode) }}" target="_blank">点击激活你的账号</a>
</body>
</html>

```

请求方式:http://localhost/laravel/public/index.php/sendMail

如果不出意外的话，可以收到邮件了。

Laravel5 发送邮件
