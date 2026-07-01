---
layout: post
title: "PHP的错误和异常"
tags: php
---

**说在最前面**

	PHP对于错误的处理相当宽容，也就是说PHP在绝大多数情况下可以忽略错误，保障PHP代码继续运行下去，也可以说PHP属于一种"exception-light"语言。可能这种对错误的宽容会导致一些难以追查的bug以及重大线上事故，但也保证了PHP开发速度快的的特性，只要程序员在编写代码时做好逻辑检查，有效的使用PHP异常机制也是可以避免大问题的。 相对于其他"exception-heavy"语言，比如Ruby，可能连接数据库的时候出错就会导致halt，而PHP则可以非常优雅的保证系统的可用性。

#
	**Error Type**

	**Basic**

-
		E_ERROR


-
		E_NOTICE


-
		E_WARNING


####
	**Others**

-
		E_STRICT : 编译时错误


	除了以上的错误常量外，其他错误常量见[http://php.net/errorfunc.constants](http://php.net/errorfunc.constants)

#
	**Error Config**

##
	**development**

display_errors = On

display_startup_errors = On

[error_reporting](http://www.php.net/error_reporting) = -1

log_errors = On

**关于error_reproting=-1这里，为什么是-1？**

>

		E_STRICT是PHP5.3.0时加入的，但它并不似E_ALL的一部分，然而到了PHP5.4.0的时候，E_STRICT加入到了E_ALL中，所以如果你使用的是PHP5.4以前的版本，如果想暴露出所有的错误信息，参考下面，则设置为-1即可。


<5.3 : -1 or E_ALL

5.3   : -1 or E_ALL | E_STRICT

>5.3  : -1 or E_ALL

##
	**production**

display_errors = Off

display_startup_errors = Off

[error_reporting](http://www.php.net/error_reporting) = E_ALL

log_errors = On

#
	**设置错误级别**

	error_reporting()

<?php

[error_reporting](http://www.php.net/error_reporting)(E_ERROR | E_WARNING);

	 

	@错误控制运算符(Error Control Operator)

<?php

echo @$foo['bar'];

###
	不建议使用@：

-
		使用@会降低php运行速度


-
		错误不会暴露出来，并且也不会保存到error_log中


	**如何禁用@错误控制运算符？**

####
	[scream](http://php.net/manual/zh/book.scream.php)

	scream以扩展的形式存在，会在php运行时刻影响@运算符的走向，具体使用方法是在php.ini设置 scream.enabled = On，或者在php代码中使用ini_set(‘scream.enabled’, true);的方式，例如官方的例子

<?php

// Make sure errors will be shown

[ini_set](http://www.php.net/ini_set)('display_errors', true);

[error_reporting](http://www.php.net/error_reporting)(E_ALL);

// Disable scream - this is the default and produce an error

[ini_set](http://www.php.net/ini_set)('scream.enabled', false);

echo "Opening http://example.com/not-existing-file\n";

@[fopen](http://www.php.net/fopen)('http://example.com/not-existing-file', 'r');

// Now enable scream and try again

[ini_set](http://www.php.net/ini_set)('scream.enabled', true);

echo "Opening http://example.com/not-existing-file\n";

@[fopen](http://www.php.net/fopen)('http://example.com/not-existing-file', 'r');

####
	[scream in XDebug](https://xdebug.org/docs/basic)

	如果事先已装好XDebug，则可以同样在php.ini种设置xdebug.scream = On来禁用@错误控制运算符，同时也可以在php代码中使用ini_get()动态设置

<?php

[ini_set](http://www.php.net/ini_set)('xdebug.scream', '1');

	 

#
	**Exception**

	对异常的处理，保证了系统的稳定性和健壮性！PHP设计了Exception基类用于接收异常。然而由于内置的Exception类相当简陋，许多框架都使用了封装后的Exception类，比如Symfony和Laravel，默认情况下Laravel使用[Whoops! ](http://filp.github.io/whoops/)来处理异常。

	有关异常，就说到这里。

PHP的错误和异常
