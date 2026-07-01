---
layout: post
title: "如何查看PHP内核堆栈执行信息？"
tags: php php-internals
---

早期在学习PHP扩展开发的时候就整理了这个.md文件，只不过一直没有发出来，看着它一直在桌面上占地方也是挺难受的，呵呵，其实也没有记录什么很高深或者很多东西，都是一些大牛的实验帖，我只是搬运工。

首先是Rango的实践贴

[使用GDB调试PHP代码，解决PHP代码死循环？](http://rango.swoole.com/archives/325)

再看鸟哥的深入内核篇

[如何调试PHP的Core之获取基本信息](http://www.laruence.com/2011/06/23/2057.html)

最后看[Derick](https://derickrethans.nl/who.html)的综合篇

[What is php doing?](https://derickrethans.nl/what-is-php-doing.html)

这篇文章介绍的比较全面，比如使用系统工具strace来查看PHP执行信息。

综上

查看PHP执行堆栈信息综合来讲有:

- .gdbinit + zbacktrace(PHP官方提供)

- gdb

- strace

- …

如何查看PHP内核堆栈执行信息？
