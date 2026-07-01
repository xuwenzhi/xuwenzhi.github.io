---
layout: post
title: "PHP扩展开发相关内核概念"
tags: php php-internals extension
---

PHP扩展开发说实话难度不大，但是却要扩展开发者拥有全面的基础知识以及要熟悉PHP内核的相关概念，这就要求我们对一些相关概念做到了如指掌。

本篇文章会针对一些新手难以理解的大概念进行解释，并大多画了流程图来更加直观的加深你的理解，以及你可能存在的疑问，比如第一个章节PHP生命周期和我们开发扩展有什么关系呢？不要着急，下面会回答你的问题。

如果你对PHP扩展开发还一点都不了解的话，也不要心急，可以看下我的这篇文章[PHP扩展开发及入门解惑](/php-extension-development-intro)来个快速上手。

**PHP生命周期**

什么叫生命周期？这里我们说的生命周期实际上是从PHP启动到终止这段过程中都做了哪些事情。在这里，我们先来个整体周期图。

PHP生命周期整体流程

Note:如图，大致可以分为PHP启动+Modules Init(MINIT)、Runtime、Modules Shutdown(MSHUTDOWN)+PHP终止这几个过程，下面我们对这几个过程进行细分。

PHP启动+MINIT过程

Runtime过程

经过上面PHP启动和各个Modules加载完成后，PHP就可以正式对外工作了。可以正式对外工作是什么意思呢？也就是说这时候如果客户端浏览器向服务器发起Request，这时的PHP就可以处理了。下面我将Runtime阶段划分成3个部分，分别解释

**Runtime 1**

Note:当客户端对服务器发起一个Request时，就会去触发这个Runtime 1的流程。主要做了Request Init过程。

**Runtime 2**

Note:这时，Request Init已经完成，接下来正式执行PHP脚本文件，比如index.php。这里会去判断是否在php.ini中设置了[auto_preappend_file](http://php.net/manual/zh/ini.core.php#ini.auto-prepend-file)，如果设置了就加载该文件，如果没有往下走正式执行index.php，再往下判断是否在php.ini中设置了[auto_append_file](http://php.net/manual/zh/ini.core.php#ini.auto-append-file)，如果设置了就加载该文件，好，Runtime 2过程就结束了。

**Runtime 3**

Note:来到这里就证明，我们所请求的index.php已经执行完毕了，但是还没完，PHP针对每一次的Request都要进行收尾工作，比如销毁一些资源变量、对象实例、刷新缓冲区和Request Shutdown的工作。

MINIT和PHP终止过程

Note:在终止阶段所有的Modules都要做Shutdown操作以及PHP最后的终止工作。

那么，看到这里你或许会有疑问：开发扩展和PHP生命周期有什么关系？

我们都知道适者生存的道理，那么想要开发好的PHP扩展如果不知道不了解PHP的生命周期，那么可能开发出好的PHP扩展吗？答案肯定是不可能的。那么我们开发的扩展和PHP的生命周期又是怎么联系起来的呢？还记得我[PHP扩展开发及入门解惑](/php-extension-development-intro)这篇文章中，关于我们扩展中最最重要的.c文件布局吗？

```
...
PHP_MINIT_FUNCTION(myfirstext)
{
    return SUCCESS;
}
PHP_MSHUTDOWN_FUNCTION(myfirstext)
{
    return SUCCESS;
}
PHP_RINIT_FUNCTION(myfirstext)
{
    return SUCCESS;
}
PHP_RSHUTDOWN_FUNCTION(myfirstext)
{
    return SUCCESS;
}
...

```

这几个函数中PHP_MINIT_FUNCTION()对应了PHP生命周期中的Modules Init，PHP_MSHUTDOWN_FUNCTION()对应了Modules Shutdown，PHP_RINIT_FUNCTION()对应了Request Init以及PHP_RSHUTDOWN_FUNCTION()对应了Request Shutdown。所以我们在编写扩展时，这几个函数是相当重要的。

另外也推荐看一下鸟哥在Yahoo!时的PPT：[The PHP Lifecycle](http://laruence-wordpress.stor.sinaapp.com/uploads/the-php-life-cycle.pdf)

**TSRM**

关于线程安全的概念，当然也是相当重要，这里我就说不上什么了，直接看鸟哥在08年写的一篇文章即可:[揭秘TSRM(Introspecting TSRM)](http://www.laruence.com/2008/08/03/201.html)

持续更新。。

PHP扩展开发相关内核概念
