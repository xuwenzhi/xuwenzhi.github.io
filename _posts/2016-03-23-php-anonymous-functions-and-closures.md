---
layout: post
title: "PHP的匿名函数和闭包"
tags: php
---

今天讨论的话题是匿名函数和闭包，这不禁让我想起当年校招的时候。在赶集的宣讲会上，赶集的技术总监说:”谁能将闭包解释明白就会拿到直通面试的资格。”，一个女生的答案得到了面试官的认可，从而得到了面试录取的机会。这件事虽小，但是还真是一直记得，不过最后也拿到了赶集的offer(不过没去)，哈哈哈，主要是开场先来个小故事，暖暖身。

提到闭包，我想大家和我一样首先会想到Js的闭包，因为这个东西在Js中用的确实比较多，但说实话我却一直不明白，说到这里真是倍感羞愧了！如果你也像我一样还不明白匿名函数和闭包这两个概念的话，那确实有义务去搞个清楚啦~注意，我这里说的是匿名函数和闭包是两个概念。

**匿名函数**

什么是匿名函数？

通俗来讲就是没有名字的函数，先看一个小例子来了解一下。

```
<?php
function use_anonymous($output){
    $output();
}
//
use_anonymous(function(){echo "我是一个匿名函数!!!";});//我是一个匿名函数!!!

```

注意:我们为use_anonymous()传递的实参实际上是一个函数，只不过因为它的确没有名字，所以叫做匿名函数。

匿名函数怎么用?

- 1. 参数的形式: 如上面的例子中，这种通过将匿名函数以参数的方式注入到另一个函数的方式。

- 2. 变量的形式: 看下面的例子，在这里我们将一个匿名函数赋值给了一个变量，当然这里其实也可以说这个函数有了个“假名字”，嗯，不是真名字，然后我们通过在变量名后面加括号()的方式来调用即可。

```
<?php

$greeting = function () {
    return "我是另一个匿名函数~";
};
echo $greeting();//output  我是另一个匿名函数~

```

当然，你可能会说create_function()也可以创建匿名函数，的确如此，但官方已经不再推荐使用了。

>

 Caution

This function internally performs an eval() and as such has the same security issues as eval(). Additionally it has bad performance and memory usage characteristics.

If you are using PHP 5.3.0 or newer a native anonymous function should be used instead.

为什么要使用匿名函数或者说匿名函数有什么好处?

- 当我们需要一个只使用一次的时候，匿名函数会很方便。

- 当我们需要一个只有一个地方调用的函数，也就是说这个函数不需要具有全局的作用域的时候，匿名函数会很方便。

**闭包**

在这里我并不想把闭包那么晦涩的定义搬到这里来，随着下面的阅读我想每个人都会对闭包有个自己的理解。

闭包和匿名函数很像，不过它比匿名函数拥有一项技能，就是它可以通过 use 把全局变量加载到局部变量中。

```
<?php
$message = '我是外部变量';
$example = function() use ($message){
    echo $message;
};
$example();

```

从该例子中，可以看出闭包和匿名函数是紧密相连的，只不过通过闭包我们将全局变量传入到了匿名函数中，这里你可能会有疑问了，那我通过global关键字不是也可以实现这个功能吗？但这一点和global不同，当我们使用global时如果在函数内部更改了变量，那自然会全局的变量，而闭包中的use不同，是不会改变的，例子说话:

```
<?php
$message = '我是外部变量';
$example = function() use ($message){
    $message = "我要变变变";//但此时全局的$message并不会变化
    echo $message;
};
$example();

```

忍不住这里放一个闭包非常经典的例子(来自官方文档)

在此例子中，通过匿名函数和闭包实现了一个”钩子”或者叫回调函数，在调用getTotal()函数时，实现了$callback的匿名函数，使得计算总额变得相当轻松和容易。

```
class Cart
{
    const PRICE_BUTTER  = 1.00;
    const PRICE_MILK    = 3.00;
    const PRICE_EGGS    = 6.95;

    protected   $products = array();

    public function add($product, $quantity)
    {
        $this->products[$product] = $quantity;
    }

    public function getQuantity($product)
    {
        return isset($this->products[$product]) ? $this->products[$product] :
            FALSE;
    }

    public function getTotal($tax)
    {
        $total = 0.00;

        $callback =
            function ($quantity, $product) use ($tax, &$total)
            {
                $pricePerItem = constant(__CLASS__ . "::PRICE_" .
                    strtoupper($product));
                $total += ($pricePerItem * $quantity) * ($tax + 1.0);
            };
        array_walk($this->products, $callback);
        return round($total, 2);
    }
}

$my_cart = new Cart;

// 往购物车里添加条目
$my_cart->add('butter', 1);
$my_cart->add('milk', 3);
$my_cart->add('eggs', 6);

// 打出出总价格，其中有 5% 的销售税.
print $my_cart->getTotal(0.05) . "\n";
// 最后结果是 54.29

```

那么闭包又有什么用或者说有什么好处？

- 从上面的例子中可以看出，使用闭包可以很容易的实现我们常说的”钩子”。

- 通过闭包，在搭配array_walk()和array_map()等函数使用时相当清爽

```
$users = array("Wenzhi", "Qmn",);
array_walk($users, function ($name) {
    echo "Hello $name<br>";
});

```

**闭包在真实场景下的应用**

看一段Laravel定义路由的例子

```
Route::get('user/(:any)', function($name){
  return "Hello " . $name;
});

```

**参考网址**

[匿名函数](http://php.net/manual/zh/functions.anonymous.php)

[What are PHP Lambdas and Closures?](http://culttt.com/2013/03/25/what-are-php-lambdas-and-closures/)

PHP的匿名函数和闭包
