---
layout: post
title: "PHP与生成器"
tags: php
---

记得早些时候看了大牛[Josh Lockhart](https://github.com/codeguy)创立的PHP学习网站[phptherightway.com](http://www.phptherightway.com/)(中文翻译:PHP之道)，非常棒的网站，从中学习到了许多现代PHP的知识，也大力推荐给了学弟学妹们，也不知道TA们有没有去学习。

    而今天看了[Josh Lockhart](https://github.com/codeguy)的《modern PHP》中介绍了生成器相关的内容，所以就研究研究。

**生成器是什么?**

PHP的生成器是5.5新增的特性，那么它到底是做什么的呢?通过一个例子来入个门

<?php

//定义一个生成器

function myGenerator($length = 10){

    for($i = 0; $i < $length; $i++){

        yield $i;

    }

}

foreach (myGenerator(50) as  $value) {

    echo $value . PHP_EOL;

}

//output

/**

*1

*2

*...

*49

*/

通过这个例子中可以看出，PHP的生成器简单来讲是升级版的foreach。

其中yield关键字还可以这样使用

yield($i);

yield([array](http://www.php.net/array)($i => $i));

**那么相较于foreach哪里升级了呢？**

我们通常会有这样类似的场景，比如遍历解析一个超大的数组或者一个CSV文件，通常的做法是foreach遍历解析数组或者这个CSV文件即可，然而通常这样的场景会消耗大量的内存(尤其在加载一个超大的CSV时)，而对于我们这些有追求的程序员绝不会容忍这样的事情发生的，对吧？而生成器这时将起到很重要的作用，比如在加载一个超大的CSV时，生成器可以将一行一行的内容以流的方式单独加载到一个区块中去，并且还能方便的做一些修改。下面通过一个benchmark来测试下到底生成器与常规的处理方式相比有何优势?

<?php

[error_reporting](http://www.php.net/error_reporting)(E_ALL);

function xrange($start, $end, $step = 1) {

    for ($i = $start; $i < $end; $i += $step) {

        yield $i;

    }

}

function urange($start, $end, $step = 1) {

    $result = [];

    for ($i = $start; $i < $end; $i += $step) {

        $result[] = $i;

    }

    return $result;

}

function testTraversable($name, callable $traversableFactory) {

    $startTime = [microtime](http://www.php.net/microtime)(true);

    foreach ($traversableFactory() as $value) {

        // noop

    }

    echo $name, ' took ', [microtime](http://www.php.net/microtime)(true) - $startTime, ' seconds.', "\n";

}

function testVariants($count) {

    testTraversable(

        "xrange        ($count)",

        function() use($count) { return xrange(0, $count); }

    );

    testTraversable(

        "urange        ($count)",

        function() use($count) { return urange(0, $count); }

    );

}

testVariants(100000);

testVariants(10000);

testVariants(100);

//output

/**

*xrange        (100000) took 0.014711856842041 seconds.

*urange        (100000) took 0.035538911819458 seconds.

*xrange        (10000) took 0.0013608932495117 seconds.

*urange        (10000) took 0.003352165222168 seconds.

*xrange        (100) took 3.9100646972656E-5 seconds.

*urange        (100) took 4.1007995605469E-5 seconds.

*/

通过此段程序，我们可以清楚的看到使用生成器的情况下将使得我们的遍历时间更短。

以下选看…

**生成器的内在**

生成器的内在

<?php

function myGenerator($length = 10){

    for($i = 0; $i < $length; $i++){

        yield $i;

    }

}

foreach (myGenerator(10) as  $value) {

    echo $value . PHP_EOL;

}

[var_dump](http://www.php.net/var_dump)(myGenerator()); //output object(Generator)#2 (0) {}

[var_dump](http://www.php.net/var_dump)(myGenerator() instanceof Iterator);//output bool(true)

从代码中可以看到Iterator这个东东，了解的同学应该知道这是PHP标准库中的迭代器(接口)，所以myGenerator类实现了Iterator接口（关于迭代器点这里[Iterator – php.net](http://php.net/manual/en/class.iterator.php)）。

而具体的调用流程，即是这样:

yield -> Generator implements Iterator{}

也就是说，Generator是PHP的一个实现了Iterator接口的内置类，当我们使用yield关键字的时候，实例化了Generator。

//官方定义的Generator类

Generator implements Iterator {

    /* Methods */

    public mixed [current](http://www.php.net/current) ( void )

    public mixed [key](http://www.php.net/key) ( void )

    public void [next](http://www.php.net/next) ( void )

    public void [rewind](http://www.php.net/rewind) ( void )

    public mixed send ( mixed $value )

    public mixed throw ( Exception $exception )

    public bool valid ( void )

    public void __wakeup ( void )

}

而一个有趣的现象是，由于Generator是一个内置类，所以你无法在PHP外部实例化Generator。

<?php

$obj = new Generator;

[var_dump](http://www.php.net/var_dump)($obj);

//output Catchable fatal error: The "Generator" class is reserved for internal use and cannot be manually instantiated

>

简单来讲，生成器是迭代器的子集。

生成器实际上就是迭代器的一个实例，只不过在PHP内核的基础上为我们实现了Iterator，具体见[zend_generator_get_iterator()](https://github.com/php/php-src/blob/master/Zend/zend_generators.c#L1181)

**那为什么存在生成器，直接使用迭代器不就行吗？**

之所以有生成器的用武之地，我觉得有以下几个原因:

- 方便，无需实现Iterator接口的好几个方法

- 专注，生成器主要在更轻量化的实现遍历

- 性能，即前面所说的性能提升

**生成器的内核实现**

[zend_generators.h](https://github.com/php/php-src/blob/master/Zend/zend_generators.h)

[zend_generators.c](https://github.com/php/php-src/blob/master/Zend/zend_generators.c)

**参考网址**

[Generators overview](http://php.net/manual/en/language.generators.overview.php)

[Microbenchmark of generator implementation](https://gist.github.com/nikic/2975796)

[Request for Comments: Generators](https://wiki.php.net/rfc/generators)

PHP与生成器
