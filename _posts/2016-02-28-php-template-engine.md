---
layout: post
title: "PHP模板引擎"
tags: php
---

**说在最前面**

	PHP代码直接可以和HTML混编在一起导致了很多人认为PHP是模板语言，但其实不然，从PHP近些年的发展以及增加的新特性都再和一个标准的模板语言背道而驰，所以认为PHP是模板语言是错误的想法。

	既然PHP不是一门模板语言，而现在主流的开发框架都遵循MVC（[MVC，MVP 和 MVVM 的图示](http://www.ruanyifeng.com/blog/2015/02/mvcmvp_mvvm.html)）模式，So，那必然有一套对模板引擎作支撑。所以在PHP的世界了充斥了各种模板引擎，比如Smarty，Twig等等。

	本文只列举PHP中流行的模板引擎、优秀模板的特点及一些有助于深入理解模板引擎的延伸阅读。

#
	**模板引擎**

##
	原生型模板

	[Plates](http://platesphp.com/) : 推荐指数3颗星

##
	编译型模板

	[Twig](http://twig.sensiolabs.org/) : symfony默认使用的模板引擎，流行指数5颗星，推荐指数5颗星。

	[Smarty](https://github.com/smarty-php/smarty/) : 这个就不用说了，补充下smarty的automatic escape功能([[转载]smarty的escape 好东西](http://blog.sina.com.cn/s/blog_64e2219d0100ve2w.html))。

	[mustache.php](http://mustache.github.io/) : 可以适配超级多的语言的模板引擎。

##
	兼原生和编译型模板

	[blade](http://0x1.im/blog/laravel/laravel-blade-engine.html?utm_source=tuicool&amp;utm_medium=referral) : 由于blade是laravel框架内置的模板引擎，支持原生同时也支持编译，灵活轻巧不失扩展性，此链接介绍了laravel中blade的执行原理。然而由于blade是嵌入在laravel框架的，如果想单独拿来用，可以看这位哥们儿拆出来的[https://github.com/XiaoLer/blade](https://github.com/XiaoLer/blade)

	那么究竟该选择哪一种？

	尽量选择编译型编译型模板引擎，比如个人推荐Twig或者blade。

##
	**优秀模板引擎的特点**

-

			security


-
				变量默认escape


-

			语法简洁


-

			支持OOP


-

			支持模板继承


-

			运行速度快


-

			可扩展


##
	**延伸阅读:**

	[Templating Engines in PHP](http://fabien.potencier.org/templating-engines-in-php.html) : 是的，又是Fabien Potencier的文章，虽然是09年的文章，但是还是可以感受到大师清晰的辩证思维。在文中，Fabien Potencier阐述了为什么不要再说php是一门模板引擎语言以及优良模板引擎的特点，最后对php中各种模板引擎进行了benchmark，该文章最下面的部分，对09年时期各种模板引擎比较结果。

	[Roll your own templating system in php ](http://code.tutsplus.com/tutorials/roll-your-own-templating-system-in-php--net-16596): 手把手教你写一个php模板引擎，虽然代码一团糟（评论区因为这个而火爆），但是看了还是有好处的。

	[An Introduction to Views & Templating in CodeIgniter](http://code.tutsplus.com/tutorials/an-introduction-to-views-templating-in-codeigniter--net-25648) : CI的视图模板介绍，评价不错。

PHP模板引擎
