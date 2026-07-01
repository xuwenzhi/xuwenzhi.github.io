---
layout: post
title: "Linux下PHP安装VLD扩展"
tags: php linux vld
---

**如果想查看OPCODE代码来实现性能优化的目的，那么需要安装VLD扩展。**

①[http://pecl.php.net/package/vld](http://pecl.php.net/package/vld) 到该地址下载最新最稳定的安装包，或者直接通过wget http://pecl.php.net/get/vld-0.13.0.tgz 下载这个包包

②解压该文件
    tar zxvf vld-0.13.0.tgz

③cd到vld-0.13.0文件内
    执行phpize ,这里要说一下的是这个phpize文件一般会因为系统的不同或安装目录的不同有着不同的路径，通过find命令可以查到我的在/usr/bin/phpize中

phpize用来干嘛的?
    是用来构建PECL扩展用的

结果报了个错，说找不到php header，到网上查了查这里貌似是一个php的bug,[https://bugs.php.net/bug.php?id=53436](https://bugs.php.net/bug.php?id=53436)。
        解决方案 : 执行 yum install php-devel

继续执行phpize

④找到php-config的位置

 执行以下命令，注意php-config的路径和上面的一致

./configure –with-php-config=/usr/bin/php-config –enable-vld

⑤编译和安装

⑥至此就安装完了，然后需要配置php.ini，将新扩展加进去

       extension=vld.so

⑦重启生效
如果服务器是apache，则重启下Apache

       service apachectl restart

 如果服务器是nginx，则重启下nginx和php-fpm
        service nginx restart

        service php-fpm restart

⑧查看phpinfo()

⑨写个简单的例子测试一下

- <?php

- $str = ‘hello world!!’;

- echo $str;

- ?>

   ⑩php -dvld.active=1 test.php

至此，也就OK了。。
Linux下PHP安装VLD扩展
