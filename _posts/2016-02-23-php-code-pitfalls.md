---
layout: post
title: "常见PHP代码写法的陷阱"
tags: php
---

**说在最前面**

PHP是一门很容易入门但很难精通的语言，容易入门原因之一是因为PHP的弱类型，这可以为新手省去许多不少的麻烦，但同时也带来了一些语言层面的陷阱以及性能的开销。但精通基本上却属于偏难的[偷笑]，任何一门语言精通都很难。本篇不会告诉你怎么精通PHP，但是会告诉你怎么避免PHP的陷阱，同时还可以知道如何写出高性能的代码。

>

以下代码在PHP 5.6.9下测试。

**不要在循环中执行Sql**

这个是首先要说的，也最容易被忽视，因为类似于下面的这种写法在逻辑上很容易理解，也方便了实现，偷懒的话一般人都会这么写。可悲的是我在实习之前一直这么写，直到实习后我的导师在帮我code review时，我才发现这个毛病！

```
foreach($array as $key => $val){
        $user = $db->findUser($val['id']);
}

```

如果这个循环执行20次，就执行了20次SQL，不但影响了查询速度还增加了数据库的压力!

**解决方案:**

在进入循环前就将数据一次批量提前出来！

**禁止在foreach中留下悬挂指针**

```
<?php
    $array = [ 1, 2, 3];
    foreach($array as &$value){
        $value *= 2;
    }
    printr($array);//output 2 4 6
    //假如你在创建了新的变量，不知道起什么名字，结果起成了$value
    $value = 100;//但$value是$array第三个变量的引用
    printr($array);//output 2 4 100

```

可能我的假如比较牵强，但是相信我，这种错误你一定会犯，尤其是团队开发，同一个函数可能会有多个人修改，尽量不要留下这种悬挂指针，利人利己。

**解决方案:**

在foreach结束后，unset($value)

**你可能会用错isset()**

```
<?php
$array = array(
        'k1' => 'v1',
        'k2' => 'v2',
        'k3' => null,
);
var_dump(isset($array['k1']));//true
var_dump(isset($array['k3']));//false

```

我们通常会用isset()检查一个变量是否被定义，或者可以你也可以检查一个数组是否有这个key。上面这段代码肯定会输出true，但是如果$val是null的话，那就会输出false了。这里其实还挺矛盾的，我确实定义了$val，但isset()却返回了false，这尼玛！

比如上面这段，我检查$array是否有’k3’这个键，由于k3对应的value是null，所以还是返回false。所以这一点还是需要注意的。

**解决方案:**

对于判断数组是否存在键这一点上，可以使用arraykeyexists()来替代，但要注意的是arraykeyexists()的性能要比isset()低多个数量级，所以对于这两个函数的选择可以根据业务场景来加以选择。

**不得不说的empty()陷阱**

```
<?php
class Regular
{
    public $test = 'value';
}
class Magic
{
    private $values = ['test' => 'value'];
    public function __get($key)
    {
        if (isset($this->values[$key])) {
            return $this->values[$key];
        }
    }
}

$regular = new Regular();
$magic = new Magic();
//正常访问
var_dump($regular->test);    // outputs string(4) "value"
var_dump($magic->test);      // outputs string(4) "value"
//使用empty()后
var_dump(empty($regular->test));    // outputs bool(false)
var_dump(empty($magic->test));      // outputs bool(true)

```

先看正常访问部分，Regular类的public属性，可以直接访问输出”value”，而Magic类则有点不同，$magic访问test属性，结果发现Magic类中并没有test这个属性，于是会自动调用__get()方法，则最终也能正确返回test的值，所以正常访问没问题。

再看使用empty()之后的结果，发现输出结果完全不同了，不同点在于empty($magic->test)按照我们的理解应该是false（因为$magic->test是可以正常返回’value’的），所以当empty()遇到__get()时如果用这种方式进行判断是很危险的。

**解决方案:**

- 尽量就不要用__get()这种方式实现ORM，同时也尽量不要用ORM

- 不要直接用empty($magic->test)这样的判断方式，可以先使用一个变量接收结果，然后再使用empty()判断

**count()小趣闻**

```
<?php
var_dump(count(10)); //int(1)
var_dump(count('string'));//int(1)

```

没错，你会发现当count()函数接收到整型和字符型的时候回默认返回1，让我们看count()的实现，实际上当传进去一个resource类型时同样也会默认返回1。今天偶然看了PHP这块儿的源码，才发现还有这么一个坑，到网上查了下，竟然还有个[小趣闻](http://www.oschina.net/question/190283_150863?sort=default&p=4)[偷笑]。

```
PHP_FUNCTION(count)
{
    ...省略
    switch (Z_TYPE_P(array)) {
        case IS_NULL:
            RETURN_LONG(0);
            break;
        case IS_ARRAY:
            RETURN_LONG (php_count_recursive (array, mode TSRMLS_CC));
            break;
        case IS_OBJECT: {
            ...省略
        }
        default:
            RETURN_LONG(1);
            break;
    }
}

```

>

源码面前了无秘密。

**参考网址:**

[PHPBench](http://phpbench.com/)

[PHP编程中10个最常见的错误](http://codecloud.net/php-2056.html)

常见PHP代码写法的陷阱
