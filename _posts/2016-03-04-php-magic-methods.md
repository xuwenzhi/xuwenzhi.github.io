---
layout: post
title: "PHP魔术方法工作机制(流程图版)"
tags: php
---

>

PHP 将所有以 __（两个下划线）开头的类方法保留为魔术方法。所以在定义类方法时，除了上述魔术方法，建议不要以 __ 为前缀。如__construct()、__destruct()、__call()等等

**提前说明:**

>

下面的流程图中，所有紫颜色区块中的自动调用__XX()函数，都是在类中存在__XX()函数的前提下执行的。

**__construct工作机制解析**

是的，我们很常用的构造函数就是一种魔术方法，由于这个都比较常用，也就不再说什么了。

```
<?php

class Foo {

    public function __construct(){
        echo '自动执行__construct()<br/>';
    }
}
$obj = new Foo();

```

以上代码输出：

*自动执行__construct()*

**__destruct工作机制解析**

同时还有析构函数也是魔术方法，对于析构函数的工作机制，这里就不再赘述了。

**__get() VS __set()**

```
<?php

class Foo {
    protected $data = array();

    public function __set($name, $value){
        echo '自动执行__set()<br/>';
        $this->data[$name] = $value;
    }

    public function __get($name){
        echo '自动执行__get()<br/>';
        if(array_key_exists($name, $this->data)){
            return $this->data[$name];
        }
    }
}
$obj = new Foo();
$obj->username = "xuwenzhi";
var_dump($obj->username);

```

以上代码输出：

*自动执行__set()

自动执行__get()

string(8) “xuwenzhi”*

**__get()工作机制解析**

>

读取不可访问属性的值时，__get() 会被调用。

**__set()工作机制解析**

>

在给不可访问属性赋值时，__set() 会被调用。

**__call() VS __callStatic()**

```
<?php

class Foo {
    public function __call($name, $argv){
        echo "自动调用__call!!<br/>";
    }

    public static function __callStatic($name, $argv){
        echo "自动调用__callStatic!!<br/>";
    }
}
$obj = new Foo();
$obj->getName();//类中并未定义getName()，所以会自动调用__call()
Foo::getName();//类中并未定义getName静态方法，所以会自动调用__callStatic()

```

以上代码输出：

*自动调用__call!!

自动调用__callStatic!!*

**__call()工作机制解析**

>

在对象中调用一个不可访问方法时，__call() 会被调用。

**__callStatic()工作机制解析**

>

用静态方式中调用一个不可访问方法时，__callStatic() 会被调用。

__callStatic的工作机制与__call()如出一辙，这里也不再赘述了。

**__isset() VS __unset()**

```
<?php

class Foo {
    protected $data = array();
    public $age = 24;//事先定义好类的成员变量
    public function __set($name, $value){
        echo '自动执行__set()<br/>';
        $this->data[$name] = $value;
    }
    public function __get($name){
        echo '自动执行__get()<br/>';
        if(array_key_exists($name, $this->data)){
            return $this->data[$name];
        }
    }
    public function __isset($name){
        echo "自动调用__isset<br/>name:".$name."<br/>";
    }
    public function __unset($name){
        echo "自动调用__unset!!<br/>name:".$name."<br/>";
    }
}
$obj = new Foo();
//动态创建属性
$obj->username = "xuwenzhi";
//使用isset()、unset()处理动态动态属性，由于username是动态创建的，所以会触发__isset()和__unset()
isset($obj->username);
unset($obj->username);
//unset类已存在的age，由于age是类中原有的属性，所以并不会触发__isset()和unset()
isset($obj->age);
unset($obj->age);

```

以上代码输出：

*自动执行__set()

自动调用__isset

name:username

自动调用__unset!!

name:username*

关于PHP中动态属性的创建问题，可以查看这篇文章[PHP独特的重载机制](/php-overloading)

**__isset()工作机制解析**

>

当对不可访问属性调用 isset() 或 empty() 时，__isset() 会被调用。

**__unset()工作机制解析**

>

当对不可访问属性调用 unset() 时，__unset() 会被调用。

**__sleep() VS __wakeup()**

```
<?php

class Foo {
    public function __sleep(){
        echo "自动执行__sleep!!<br/>";
        return array();
    }

    public function __wakeup(){
        echo "自动执行__wakeup!!<br/>";
        return array();
    }
}
$obj = new Foo();
$str = serialize($obj);//序列化时，自动调用__sleep()
unserialize($str);//反序列化时，自动调用__wakeup()

```

以上代码输出：

*自动执行__sleep!!

自动执行__wakeup!!*

**__sleep()工作机制解析**

>

serialize() 函数会检查类中是否存在一个魔术方法 __sleep()。如果存在，该方法会先被调用，然后才执行序列化操作。

**__wakeup()工作机制解析**

>

unserialize() 会检查是否存在一个 __wakeup() 方法。如果存在，则会先调用 __wakeup 方法，预先准备对象需要的资源。

**__invoke()工作机制解析**

```
<?php

class Foo {
    public function __invoke($name){
        echo "自动调用__invoke!!<br/>";
    }
}
$obj = new Foo();
$obj(1);//尝试以函数的方式来使用对象，则会自动调用__invoke()

```

以上代码输出：

*

自动调用__invoke!!*

>

当尝试以调用函数的方式调用一个对象时，__invoke() 方法会被自动调用。

**__toString()工作机制解析**

```
<?php

class Foo {
    public function __toString(){
        echo '自动调用__toString!!<br/>';
        return '';//__toString()一定要返回字符串
    }
}
$obj = new Foo();
echo $obj;//当试图去使用echo输出一个对象时，会自动调用__toString()

```

以上代码输出：

*自动调用__toString!!*

>

__toString() 方法用于一个类被当成字符串时应怎样回应。例如 echo $obj; 应该显示些什么。此方法必须返回一个字符串，否则将发出一条 E_RECOVERABLE_ERROR 级别的致命错误。

Warning

不能在 __toString() 方法中抛出异常。这么做会导致致命错误。

**__set_state()工作机制解析**

```
<?php

class Foo {
    public function __set_state($name){
        echo "自动调用__set_state!!<br/>";
    }
}
$obj = new Foo();
echo var_export($obj);//当使用var_export()打印一个对象的时候，会自动调用__set_state()

```

以上代码输出：

*自动调用__set_state!!*

>

自 PHP 5.1.0 起当调用 var_export() 导出类时，此静态 方法会被调用。

**__debugInfo()工作机制解析**

```
<?php

class Foo {
    public function __debugInfo(){
        echo "自动调用__debugInfo!<br/>";
        return array();//__debugInfo()一定要返回数组
    }
}
$obj = new Foo();
echo var_dump($obj);//当使用var_dump()打印一个对象的时候，会自动调用__debugInfo()

```

以上代码输出：

*自动调用__debugInfo!

object(Foo)#1 (0) { }*

>

当使用var_dump()打印一个类的对象时，将会自动触发该函数。如果该类定义了__debugInfo()函数，则可以个性化的打印一些需要的信息；当该类未定义__debugInfo()函数时，会打印类的所有属性，包括public、protected和private。

This feature was added in PHP 5.6.0.

**总结**

可见，PHP因为有了魔术方法而变得富有了灵力，上面对于各种魔术方法的介绍以及工作原理的解释基本上也都属于比较简单的概念。随着PHP生涯之路走的越远，对于各种魔术方法的使用也会游刃有余，所以归根结底还是要多练多写多打磨。

然而，并不是说使用魔术方法就是好的，事物的双面性原则，灵活的背后也是要付出性能代价的。所以慎用。

**参考网址**

[PHP：魔术方法](http://php.net/manual/zh/language.oop5.magic.php)

PHP魔术方法工作机制(流程图版)
