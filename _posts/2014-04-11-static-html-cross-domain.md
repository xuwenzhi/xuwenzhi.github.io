---
layout: post
title: "静态HTML与服务器跨域交互初探"
tags: html ajax cross-domain
---

由于在帮助实践与创新中心的伙伴们完成他们的创新实验项目，所以我加入到了考勤开发的项目中，因为要有一个Android的客户端为成果，但是自己又不会用原生的Java来开发，所以决定用之前学过的PhoneGap+HTML5来完成这项工作。

   昨晚完成了整个APP的界面设计，所以就开始完成业务逻辑方面的代码工作，因为之前做过一个类似用PhoneGap的客户端，是通过jQuery+Ajax来和自己的电脑来进行交互所以没有遇到什么交互不了的问题，但是这次是通过Ajax来和远程服务器进行交互，结果Ajax一直显示连接错误。

```
$.ajax({
   type:'post',
   url:'http://202..........'........
   success:function(data){},
   error(x, s){
       alert('与服务器连接不上');
   }
});

```

所以就觉得难以理解了，于是只能百度或者Google了，经过一系列的查询，发现其实这样的问题并不难解决，其实只需要它 JSONP,其实之前在学习jQuery中的Ajax的时候就已经接触过它，只不过那个时候没有在意它这么强大的功能。

JSONP为什么可以实现跨域操作呢?

 JSONP方式的交互方式和Script方式是一样的。本身XMLHttpRequest本身不能跨域操作，但是script标签的src是可以跨域访问，使用jQuery的JSONP就可以实现跨域操作。

JSONP的使用格式？

        function(json对象)；（function是客户端定义的函数的名字）

        url?callback =function      (客户端需要按照此形式来定义格式)

不过通过JSONP从跨域服务器中返回的数据是不是一定是JSON数据，敝人还没有验证，不过为什么不使用JSON格式呢，可想而知与服务器交互应该控制流量的大小才是，因为JSON格式的轻量化，选择JSON格式似乎好处多多,如果想更深入的了解JSONP可以参考最下方的第一个参考网址。

下面看一个具体的例子来看如何使用JSONP？

  无论是原生的JS，还是一些封装好的JS框架都对JSONP有了一个很好的支持，所以在这里我是通过jQuery来实现这种跨域操作。

1、首先我的界面是这个样子的，前端代码使用了jQuery Mobile框架

```
<div role="main" class="ui-content">
        <h1 class="center">学生登录</h1>
        <form>
    <ul data-role="listview" data-inset="true">
        <li class="ui-field-contain">
            <label for="username">学号</label>
            <input type="text" name="username" id="username" value="" data-clear-btn="true">
        </li>
        <li class="ui-field-contain">
            <label for="password">密码</label>
            <input type="password" name="password" id="password" value="" data-clear-btn="true">
        </li>
        <li class="ui-body ui-body-a">
              <input type="button" class="login_button" class="ui-btn ui-btn-a" value="登录" />
        </li>
    </ul>
    </form>
    </div><!-- /content -->

```

2、JS代码:由于JS代码过长，我将其中的一部分跨域验证演示出来，仅供参考，比如当我输入完学号之后，需要到服务器中验证是否存在这个学号，如果不存在就提示一下.

```
var username = $("#username").val();//输入的学号
    $.getJSON(DOMAIN_NAME+"Login/jsonpCheckUser?u="+username+"&type=stu&callback=?", function(data){
        if(parseInt(data.res) != 1){
            $(".brush_window").html('学号不存在');
                $(".brush_window").css('left', width/2-60);
                $(".brush_window").css('top', height/2);
                $(".brush_window").slideDown();
                setTimeout("$('.brush_window').fadeOut(1500);",1500);//设置1.5S关闭该弹窗
            }
    });

```

在jQuery中通过getJSON()函数来使用JSONP，发现函数的第一个参数为服务器文件地址，其他的不重要，重要的是在最后存在一个callback=?，这是getJSON()的一个回调机制。

3、服务器端代码，这里我使用的是PHP。

```
function jsonpCheckLogin(){
  if(isset($_GET['callback'])){  //判断是否有callback
            $callback = $_GET['callback'];
        }else{
            $callback = '';
        }
        .....
       这里就是需要进行判断，这个学号是否存在
       .....
       if(!empty($callback)){
       $json = $callback."(".$json.")";
       }
       echo $json;
}

```

通过firebug中的网络可以看到详细的交互信息。

基本的内容就是这些，当然我的这段代码有许多缺陷

有安全缺陷，在与服务器交互的过程中，许多有关用户隐私的信息都暴漏在了URL中，这是不可取的，如果读者有想法，可以告诉我哦。

当然对于解决跨域数据交互的方式超多超多，Jsonp也只是其中比较简单的一个。

其他常用的跨域请求方式有：

• window.postMessage

• window.name

• Server-Proxy

• document.domain

• FIM

• Flash

参考网址：[http://www.cnblogs.com/dowinning/archive/2012/04/19/json-jsonp-jquery.html](http://www.cnblogs.com/dowinning/archive/2012/04/19/json-jsonp-jquery.html)      (JSON和JSONP的区别)

静态HTML与服务器跨域交互初探
