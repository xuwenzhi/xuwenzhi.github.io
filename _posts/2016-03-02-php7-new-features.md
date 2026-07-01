---
layout: post
title: "PHP7语法新特性"
tags: php php7
---

PHP7.0.0距今发布已经两三个月了，而今7.0.3也已经发布了将近一个月，再不搞搞PHP7可能就要落伍啦。

对于PHP7相较于PHP5的一些重大提升，比如性能提升、PHPNg、AST等等的变化在这里就不做赘述了，有相当多的文章已经对此进行了介绍，比如[PHP7新特性 What will be in PHP 7/PHPNG](http://blog.csdn.net/hguisu/article/details/45094079)。本文只对PHP7在语法层面新增的特性以及变化做一个简要的了解。

**返回值类型的限定**

php的弱类型特性带给我们相当大的便利，同时也带来了一些难以捕获的bug，比如我们通常定义一个函数，自认为这个函数会返回一个array，但是可能会因为某些原因返回了null，从而导致调用者掉进坑里，这样的事情本人真的遇到过。**所以处理返回值应该相当小心！**而现在随着PHP7加入返回值类型的限定，则使得PHP语法进入了相对严格的时代。比如下面的例子，在函数定义后面加上 “: int” 这样的方式，则要求该函数必须返回整型。

<?php

class Rtd {

        public function retTypeDeclare() : int{

                return 2016;

        }

}

$obj_rtd = new Rtd();

[var_dump](http://www.php.net/var_dump)($obj_rtd->retTypeDeclare());

延伸实验

试试将代码中 2016 修改成 ‘2016’或修改成 ‘hello monkey’或修改成 [‘2016’] 后分别会有什么样的结果。

虽然，新加入的返回值类型限定拥有着不错的优点，但是在某些情况下会变得有点蹩脚，比如我们的Rtd是实现了某个接口而来的，则我们的接口中的函数定义也需要加上 ” : int “才行，否则会报错，不过这个是可以接受的。

<?php

interface RtdTemplate {

        public function retTypeDeclare() : int;

}

class Rtd implements RtdTemplate{

        public function retTypeDeclare() : int{

                return 2016;

        }

}

$obj_rtd = new Rtd();

[var_dump](http://www.php.net/var_dump)($obj_rtd->retTypeDeclare());

**变量类型限定**

首先，看下面的代码，一个变化就是函数的参数类型得到了限定。

<?php

function scalarTypeDeclare(int $left, string $right){

        return $left + $right;

}

[var_dump](http://www.php.net/var_dump)(scalarTypeDeclare(2016, "hello monkey"));

延伸实验

试试将代码中 “hello monkey” 修改成 2016或修改成 null 或 修改成 [‘2016’]或false 后分别会有什么样的结果。

如果你试了的话，基本上可以总结一点，这种变量的限定其实也不会太过严格。假如函数参数是String，我传进去Boolean或Integer实际上并不会报错，而如果是array、null、obj的话就会报错了。

**奇葩运算符之 ?? **

不要标题党，此奇葩非彼奇葩。

看下面这个例子中，比较陌生的应该就是 ” ?? “了，还记得以前的 ” ? : “三元运算符嘛？这个实际上就是为了简化这个而设计的，如果 ” ?? “左边的表达式为false的话，则会执行 ” ?? “右侧的部分。

<?php

//是否是闰年

function isRunYear(int $toyear) : bool{

     return true;

}

$toyear = 2016;

$year_type = '是闰年';

$year_type = isRunYear($toyear) ?? '不是闰年';

echo $year_type;

**奇葩运算符之 <=>**

一个简单的例子了解。

<?php

[var_dump](http://www.php.net/var_dump)(1 <=> 0);// 1

[var_dump](http://www.php.net/var_dump)(1 <=> 1);// 0

[var_dump](http://www.php.net/var_dump)(0 <=> 1);// -1

**定义常量数组**

从PHP7起，就可以这么风骚的定义常量数组了，请容许我在说一句，太尼玛风骚了！

<?php

//const

const REVIEW = ['good', 'bad'];

[var_dump](http://www.php.net/var_dump)(REVIEW);

//define

[define](http://www.php.net/define)('SEX', ['male', 'female']);

[var_dump](http://www.php.net/var_dump)(SEX);

**匿名类**

早在PHP7之前，仅有匿名函数的存在，PHP7将匿名类也加上了，还是痛快儿的给例子了~实在也没想出来个好例子，就以我们程序猿上班打卡来个小例子

<?php

class Programmer{

        public $punch_clock = null;

        public function __construct($pc){

                $this->punch_clock = $pc;

        }

}

$programmer = new Programmer(

    new Class{

         public function doPunchClock(){

               echo '打卡';

         }

    }

);

$programmer->punch_clock->doPunchClock();

**命名空间用户组**

以前，如果你需要实用某个类，需要不停的use 命名空间，比如这样

<?php

namespace Namespace;

use App\Http\Request;

use App\Http\Response;

use App\Http\Ajax;

...

而在PHP7的世界里将不再烦恼了，只需这样

<?php

namespace Namespace;

use App\Http\{Request, Response, Ajax, ...};

真的是个超级实用的功能！

PHP7在语法上给了我们很惊艳的变化，然而最最惊艳的还是PHP7大幅度的性能提升，对于PHP7更加详尽的了解，请参考文章开头的那篇文章，整体写的很详尽~

**参考网址**

[PHP7新特性 What will be in PHP 7/PHPNG](http://blog.csdn.net/hguisu/article/details/45094079)

[PHP Pandas: PHP7](http://daylerees.com/php-pandas-php7/)

**延伸阅读**

[PHP SYDNEY MAR. 12, 2015 From Rasmus Lerdorf](http://talks.php.net/oz15#/)

PHP7语法新特性
