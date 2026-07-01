---
layout: post
title: "PHP独特的重载机制"
tags: php
---

重载是是众多编程语言都有的一个特性，通常我们所说的重载包含属性重载、方法重载甚至C++还有运算符重载。

在其他编程语言如Java、C++中，重载一般针对方法而言，当满足1、函数参数的个数不一样。2、参数的类型不一样 这就叫重载或者叫做函数重载。而PHP所提供的”重载”（overloading）是指动态地”创建”类属性和方法。这个和其他语言中的重载概念是不一样的。

**问题来了？**

**问题1：**既然PHP的重载和其他编程语言的重载根本是不同的概念，那究竟可不可以实现其他语言的那种版本的重载？

答：看这里[PHP 函数重载](http://blog.csdn.net/smartyidiot/article/details/6126761)

**问题2：**那究竟PHP的重载是什么意思呢？

答：我们再来重新温习一下这段话 “PHP所提供的”重载”（overloading）是指动态地”创建”类属性和方法”，我们注意到其中有个”动态地”这样的一个词，意思就是说我们可以动态的为类创建属性和方法，PHP以[魔术方法](http://php.net/language.oop5.magic)来实现这一的功能(如果你还不了解这几个函数的功能，建议先移步[魔术方法](http://php.net/language.oop5.magic)了解一番)。

>

__get()、__set()可以实现动态创建属性，而__call()、__callStatic()来实现动态函数创建。

**动态创建属性是怎么玩的呢？**

<?php

class Redeclare{

    //存储动态创建的属性

    public $data = [array](http://www.php.net/array)();

    /**

     * 获取动态创建的属性

     */

    public function __get($name){

        echo '获取动态变量:'. $name .'<br/>';

        //获取动态创建的变量

        $data = $this->data;

        if([array_key_exists](http://www.php.net/array_key_exists)($name, $data)){

            return $data[$name];

        }

        echo '类'. __CLASS__.'不存在属性'. $name .'<br/>';

    }

    /**

     * 创建动态属性

     */

    public function __set($name, $value){

        echo '动态创建变量: key:'. $name .', value:'. $value .'<br/>';

        $this->data[$name] = $value;

    }

}

$obj = new Redeclare;

$obj->username = "xuwenzhi";

[var_dump](http://www.php.net/var_dump)($obj->username);

**以上代码输出:**

动态创建变量: key:username, value:xuwenzhi

获取动态变量:username

string(8) “xuwenzhi”

要理解这个例子其实并不难，只需要理解了__get()和__set()的工作方式即可了，来看这里整理的流程图。

__get()工作机制

__set()工作机制

**问题来了？**

在上面的代码中，仅仅使用__get()和__set()就完成了PHP重载中的动态创建属性功能。但是问题来了，OOP的一大特性就是封装，也就是说类中什么样子的对于使用者来讲应该是不透明的。

**问题1：**假如我们的类Redeclare中最初是这样的，然而类Redeclare的使用者发起了这样的操作$obj->age = 24;了，那么会发生什么呢？

class Redeclare{

//我们定义了一个public 属性

public $age = null;

//存储动态创建的属性

public $data = [array](http://www.php.net/array)();

...

答:如果你已经深入的理解了__set()的工作原理的话，那么这条语句并不会走进__set()中，也就是说$obj->age = 24;并不会动态创建属性。

**问题2：**我们上面的例子中，$age是public的，如果改为private，会怎样？

class Redeclare{

//我们定义了一个private 属性

private $age = null;

//存储动态创建的属性

public $data = [array](http://www.php.net/array)();

...

答：这时如果你跟上的我的脚步的话，可以想象一下，因为$age并不是public的，所以$obj是没有权限通过 “->” 调用的，按照上面__set()的工作机制来看，一定会走进__set()里面了，所以这个时候我们的$age会被动态创建出来。

<?php

class Redeclare{

    private $age = null;

    //存储动态创建的属性

    public $data = [array](http://www.php.net/array)();

    /**

     * 获取动态创建的属性

     */

    public function __get($name){

        echo '获取动态变量:'. $name .'<br/>';

        //获取动态创建的变量

        $data = $this->data;

        if([array_key_exists](http://www.php.net/array_key_exists)($name, $data)){

            return $data[$name];

        }

        echo '类'. __CLASS__.'不存在属性'. $name .'<br/>';

    }

    /**

     * 创建动态属性

     */

    public function __set($name, $value){

        echo '动态创建变量: key:'. $name .', value:'. $value .'<br/>';

        $this->data[$name] = $value;

    }

}

$obj = new Redeclare;

$obj->username = "xuwenzhi";

[var_dump](http://www.php.net/var_dump)($obj->username);

echo '<br/>';

$obj->age = "24";

[var_dump](http://www.php.net/var_dump)($obj->age);

**以上代码输出:**

动态创建变量: key:username, value:xuwenzhi

获取动态变量:username

string(8) “xuwenzhi”

动态创建变量: key:age, value:24

获取动态变量:age

string(2) “24”

当然，至此对于PHP创建动态属性就告一段落，上面我卖了个关子，如果你使用了PHP的这种特性的话，那么一定会去保证代码的健壮性和性能，__isset()、__unset())这两个哥们儿你值得拥有，具体怎么用，实践出真知。

**动态创建方法又是怎么玩的呢？**

这里，我们将要与__call()、__callStatic()来个近距离接触，它们两个工作机制是一模一样的，所以这里只列出__call()的工作机制。

还是看具体的例子。

<?php

class Redeclare{

    public function __call($name, $value){

        echo $name;

        [var_dump](http://www.php.net/var_dump)($value);

    }

    public static function __callStatic($name, $value){

        echo $name;

        [var_dump](http://www.php.net/var_dump)($value);

    }

}

$obj = new Redeclare;

$obj->getName('call');

echo "<br/>";

Redeclare::getName('callStatic');

**以上代码输出:**

getNamearray(1) { [0]=> string(4) “call” }

getNamearray(1) { [0]=> string(10) “callStatic” }

好吧，这里就不做过多解释了，很容易理解的东西。

**总结**

看到这里你肯定很蒙，我也是。大体上可以认为此PHP重载非其他语言的重载，所以很容易给人造成误解。另外很奇怪的一点是不知道为什么会给这种机制叫做重载？Why?Why?Why? 不过既然已经这样子了，那也不能踩坑啊，尤其是面试的时候，面试官问你PHP重载，你答非所问就悲剧了。

PHP独特的重载机制
