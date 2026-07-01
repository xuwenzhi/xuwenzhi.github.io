---
layout: post
title: "PHP Cli模式下调用系统VIM（exec()）"
tags: php cli
---

```
最近在搞一个比较好玩的东西，就不说什么东西了，但是里面涉及到一个功能，就是PHP调起Linux系统下的vim进而显示文件内容，做一个简单的记录吧。

```

```
//...省略
system ('echo "\nPlease edit this file"' . $file_path);
system ("vim $file_path > `tty`");

```

当然PHP调用系统的函数有很多，具体用法可以参考官方文档，这里就不详述了。

PHP Cli模式下调用系统VIM（exec()）
