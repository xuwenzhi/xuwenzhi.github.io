---
layout: post
title: "Lnmp环境使用Yaf框架并实现输出Hello Yaf例子"
tags: php yaf lnmp
---

Yaf(Yet Another Framework)是鸟哥在百度时期写的C扩展框架，与其他框架相比在性能上已经不是一个量级。本文主要对Yaf做了一个简单的入门，以及一些简单技巧。

**安装**

    ①下载最新的yaf压缩包

    ②解压
        

    ③编译Yaf
        cd yaf-2.2.8   #进入该目录
        找到phpize所在的目录，由下图中可以看到在 /usr/bin下

执行命令/usr/bin/phpize
       

继续编译，下面红框部分中的php-config和phpize在同一目录下
       

执行make命令
       

make安装
       

③增加yaf扩展进php.ini，保存退出
      

④重启php
       由于是Nginx，所以执行命令，service php-fpm restart

**Hello Yaf!快速例子**

小提示:如果你的Linux已经安装好了git并且已经连接好了github，可以参考下面的代码生成工具来做Yaf小项目的基础配置。
如果想配置git连接到github，可以参考我的另一篇文章[http://blog.csdn.net/u014646984/article/details/43677959](http://blog.csdn.net/u014646984/article/details/43677959)

  ①项目基础配备
       新建一个项目yaf，在其中建立application，conf这两个目录和两个文件index.php 和 .htaccess
       

②入口文件
       index.php，输入以下内容，保存并退出
       

    ③从写规则
       打开.htaccess文件，因为我的服务器是Nginx，所以输入以下内容，保存并退出
       

 ④代码准备
       进入application目录下，在其中建立如下目录
       controllers :  控制器层
       library        :  放Yaf库文件
       models      :  逻辑层
       modules    :  数据层
       plugins      :  插件
       views         :  UI文件夹
       

 ⒈进入到controllers目录下
           新建一个php文件Index.php，输入如下内容，保存并退出
       

      2.退出controllers文件夹，进入views文件夹
           新建一个index文件夹并且进入到index文件夹内，新建文件index.phtml，输入以下HTML代码
       

       ⒊剩余的models、modules和plugins等文件夹暂时不用去动

    ⑤配置文件
       回退到项目根目录，进入到conf文件夹内，新建一个叫做application.ini文件,编辑它，输入以下内容，保存并退出
        

 ⑥Run
        

**使用代码生成工具（选看）**

上面一共用了6个步骤才算完成配置，似乎有点复杂，但是鸟哥已经为我们提供好了一个自动化的生成项目的工具yaf_cg，需要到github上把这个工具pull下来，yaf_cg是php-yaf其中的一个工具，现在我们把整个的php-yaf pull下来。

⒈新建文件夹php_yaf,初始化git
        

        

⒉将代码pull下来，好，可以看到一个新的分支被拉下来了。
        

⒊执行ls，查看到多了很多文件和目录，进入tools/cg目录下，执行命令./yaf_cg yaf_cg_demo (yaf_cg_demo为项目名称)，发现DONE，说明已经通过CG生成了项目的基础架构
        

最后，生成了一个output文件夹，output下就是生成的项目文件夹，进入yaf_cg_demo，结果发现里面已经存在了基础的文件和目录。
        

 

Lnmp环境使用Yaf框架并实现输出Hello Yaf例子
