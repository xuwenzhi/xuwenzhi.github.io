---
layout: post
title: "PhoneGap+JQM"
tags: phonegap jquery-mobile
---

**一、phoneGap返回上一页的问题**

使用phonegap内置的 navigator.app.backHistory(); 即可。

**二、JQM页面通过data-ajax=’true’的情况下进行页面切换时，总是出现两次白色闪屏的问题**

这一点主要由JQM通过Ajax换场引起，可以通过下面的方法来解决掉这种闪屏的情况。

①在CSS代码中加上

[cc lang=”css” theme=”vibrant” width=”100%” height=”700″ lines=”40″ noborder=”true”]

.ui-page{

    -webkit-backface-visibility : hidden;

    backface-visibility : hidden;

    -moz-backface-visibility : hidden;

}

[/cc]

虽然大多数移动设备都是通过WebKit渲染页面，但是加上后两行有备无患。

[cc lang=”css” theme=”vibrant” width=”100%” height=”700″ lines=”40″ noborder=”true”]

.ui-mobile-rendering > * { 

    visibility: hidden; 

}

[/cc]

来自 [http://stackoverflow.com/questions/17962378/white-page-when-loading-while-using-jquery-mobile](http://stackoverflow.com/questions/17962378/white-page-when-loading-while-using-jquery-mobile)

②在JS代码中加入

[cc lang=”js” theme=”vibrant” width=”100%” height=”700″ lines=”40″ noborder=”true”]

$.mobile.defaultPageTransition = ‘none’;

[/cc]

注意这段代码移动要放在<script src=”jquery.js”></script> 和 <script src=”jquery-mobile.js”></script>中间

这样基本就可以解决了页面切换时两次白屏的情况，但是其实JQM的效果还是不尽如人意，还是会有一次白屏的情况，估计也只能做到这样子了。

**三、为PhoneGap开发的Android应用加入splash screen，也就是启动时的动画**

在Android启动文件的super.loadUrl(),之前加入super.setIntegerProperty(“splashscreen”, R.drawable.bg_dreams);bg_dreams为启动动画的名称，也就是bg_dreams.png，需要注意的是一定要在super.loadUrl()，添加第二个参数为毫秒数，也就是动画显示的时间。

然后需要在res的所有drawable开头的文件夹中加入bg_dreams.png图片

这样就可以实现PhoneGap的splash screen动画效果了。

参考自[http://wap.blog.163.com/w2/blogDetail.do?u=http://blog.163.com/liufeng3980312/blog/static/11506465020127103821539](http://wap.blog.163.com/w2/blogDetail.do?u=http://blog.163.com/liufeng3980312/blog/static/11506465020127103821539)

**四、当在一个页面中写入了多个JQM page的时候，如何绑定页面切换事件**

[cc lang=”html” theme=”vibrant” width=”100%” height=”700″ lines=”40″ noborder=”true”]

page1

[page2](#page2)

page2

[page1](#page1)

[/cc]

也就是在一个body中存在多个page,那么当各个page之间进行切换的时候，如何绑定事件,例如当点击page2时会进入page2页面中，则可以初始化这个page2

[cc lang=”javascript” theme=”vibrant” width=”100%” height=”700″ lines=”40″ noborder=”true”]

$(document).on(“pageinit”,”#page2″,function(){

    //绑定当页面跳转到 #page2时

});

[/cc]

**五、为PhoneGap程序(安卓)添加菜单按钮**

其实为Phonegap的应用加入菜单选项，其实方法还是很多的，主要有两种方法

①使用Native自带的菜单项

②使用PhoneGap提供的API监听是否点击了菜单按钮，然后自己提供一个HTML页面显示在菜单处即可

这里面我使用的是通过Native的方法来创建菜单，

①首先在主程序MainActivity.java的MainActivity类中添加如下的方法

[cc lang=”java” theme=”vibrant” width=”100%” height=”700″ lines=”40″ noborder=”true”]

@Override

    public boolean onCreateOptionsMenu(Menu menu) {

		menu.add(0,1,1,R.string.about);

        menu.add(0,2,2,R.string.navigation);

        menu.add(0,3,3,R.string.exit);

            // TODO Auto-generated method stub

        return super.onCreateOptionsMenu(menu);

    }

    @Override

    public boolean onOptionsItemSelected(MenuItem item) {

            if(item.getItemId()==3){

            	finish();

            }

            if(item.getItemId()==1){

                    super.loadUrl(“file:///android_asset/www/test.html”);

	    }

            if(item.getItemId()==2){

            	super.loadUrl(“file:///android_asset/www/test.html”);

            }

            return super.onOptionsItemSelected(item);

    }

[/cc]

②然后项目文件夹下/res/values/下新建一个叫做string.xml的文件，具体的菜单就是内容就是写在这里

[cc lang=”xml” theme=”vibrant” width=”100%” height=”700″ lines=”40″ noborder=”true”]

    app

    退出

    关于

    导航

[/cc]

注意:string.xml中的第二行，一定要保留住了。

[cc lang=”xml” theme=”vibrant” width=”100%” height=”700″ lines=”40″ noborder=”true”]

app

[/cc]

**但是还是Eclipse还是报这个错误**

所以还有第三步,就可以解决掉这个问题

[cc lang=”java” theme=”vibrant” width=”100%” height=”700″ lines=”40″ noborder=”true”]

import android.os.Bundle;

import android.app.Activity;

import org.apache.cordova.DroidGap;

import org.apache.*;

import android.view.Menu;

import android.view.MenuItem;

[/cc]

当我没有添加

[cc lang=”java” theme=”vibrant” width=”100%” height=”700″ lines=”40″ noborder=”true”]

org.apache.cordova.DroidGap;

[/cc]

这行代码的时候，就会出现这个报错，意思是不让我重写onCreateOptionsMenu()这个方法，但是我不知道为什么，不过能解决问题就好了。

如果不出问题，phonegap中增加菜单的功能就OK了。

参考网址:

[http://developer.android.com/guide/topics/ui/menus.html](http://developer.android.com/guide/topics/ui/menus.html)

[http://tech.soft6.com/660/1/3662.html](http://tech.soft6.com/660/1/3662.html)

[http://blog.csdn.net/lijiacumt/article/details/7386185](http://blog.csdn.net/lijiacumt/article/details/7386185)

**六、JQM的header和footer处理问题**

使用过JQM的同学都知道，JQM提供的header和footer可以一直紧贴在上方和下方，但是footer会有个问题，就是当点击页面中的content部分时，footer会消失，再次点击content部分时footer就会再次出现，解决这个问题非常简单，只要在footer中加入data-tap-toggle=”false”即可。

[cc lang=”html” theme=”vibrant” width=”100%” height=”700″ lines=”40″ noborder=”true”]

- [设置](#gear_panel)

- [进入学习]()

- [消息]()

[/cc]

PhoneGap+JQM
