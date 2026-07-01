---
layout: post
title: "Composer使用PEAR包"
tags: php composer pear
---

	**什么是PEAR？**

	一句话来说，就是上一代的composer。也就是说在还没有出现composer的年代，PEAR（the PHP Extension and Application Repository PHP扩展与应用库）作为PHP开发者的包管理系统付出了相当大的贡献，那么PEAR都做了什么呢？

	1.PEAR按照一定的分类来管理PEAR应用代码库，你的PEAR代码可以组织到其中适当的目录中，其他的人可以方便地检索并分享到你的成果。

	2.PEAR不仅仅是一个代码仓库，它同时也是一个标准，使用这个标准来书写你的PHP代码，将会增强你的程序的可读性，复用性，减少出错的几率。

	3.PEAR通过提供2个类为你搭建了一个框架，实现了诸如析构函数，错误捕获功能，你通过继承就可以使用这些功能。

	以上3条复制自[PHP PEAR简介](http://www.php100.com/html/webkaifa/PHP/PHPyingyong/2008/1224/270.html)(发布时间：2008-12-24 00:00:00，确实很古老。)

	 

	**进入正题**

	啥叫Composer使用PEAR的包？

	大家知道，在composer还没出现之前，全世界的开发者的开源库都是由PEAR来维护，所以直至composer出现之前，已经相当数量级的开源库是放在PEAR上的。

	那么问题来了，如何使用composer去安装PEAR上的库呢？

	 

	**操作开始**

	1.新建一个文件夹，命名随意，我这里命名为pear。

	2.composer init

	    使用composer初始化这个目录，一路回车即可，不需要填写任何信息，我们只是做实验。如果实在不明白，可以参考我的另一篇文章[构建自己的composer包](/build-your-own-composer-package)

	3.编辑生成的composer.json文件成下面这样

{

    "repositories": [

        {

            "type": "pear",

            "url": "https://pear2.php.net"

        }

    ],

    "require": {

        "pear-pear2.php.net/PEAR2_Text_Markdown": "*"

    }

}

	你可能已经注意到了repositories块儿中的type设置成了pear，而url设置成了pear的网站，就是这个意思，而require块儿中，我们只需要列出我们需要使用的开源库即可，这里我选择安装PEAR2_Text_Markdown这个库。

	然而，你可能会问了，这pear后面的2是咋回事？这又涉及到了一个概念，PEAR2是升级版的PEAR，而你可以就理解为PEAR2就是PEAR即可。有关于PEAR2的更多信息[What is the difference between PEAR and PEAR2?](http://stackoverflow.com/questions/5409039/what-is-the-difference-between-pear-and-pear2)

	4.composer install

	如果你看到这个，就证明已经成功通过composer安装器从PEAR安装了开源库，而composer的autoloader也会自动将PEAR2_Text_Markdown加载进来。So，就是这么简单!

	 

	**参考网址**

	**[PEAR#](https://getcomposer.org/doc/05-repositories.md#pear)**

	[PHP PEAR简介](http://www.php100.com/html/webkaifa/PHP/PHPyingyong/2008/1224/270.html)

	[What is the difference between PEAR and PEAR2?](http://stackoverflow.com/questions/5409039/what-is-the-difference-between-pear-and-pear2)

	 

Composer使用PEAR包
