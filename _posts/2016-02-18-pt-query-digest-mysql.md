---
layout: post
title: "使用pt-query-digest分析mysql"
tags: mysql performance
---

**讲在前面**

最近在看《高性能MySQL》，作者们背靠Percona向我展示了以前从不知道的一些关于MySQL的知识以及各种分析优化工具，比如这里要说的pt-query-digest。

**什么是pt-query-digest?**

pt-query-digest是一个可以分析MySQL日志(query、slow和binglog)、processlist和tcpdump的工具。

**安装篇**

pt-query-disest是用Perl写的一个文件，下载下来就可以使用。将下载下来的pt-query-digest文件放在环境变量目录下，方便使用。

```
wget percona.com/get/pt-query-digest
chmod u+x pt-query-digest

```

**准备篇**

执行命令 pt-query-digest ，发现如下错误信息，原因在于我们的系统缺少一个Perl包导致的。

```
Can't locate Time/HiRes.pm in @INC (@INC contains: /usr/local/lib64/perl5 /usr/local/share/perl5 /usr/lib64/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib64/perl5 /usr/share/perl5 .) at /usr/local/bin/pt-query-digest line 3187.
BEGIN failed--compilation aborted at /usr/local/bin/pt-query-digest line 3187.

```

解决方案

```
yum install -y perl-Time-HiRes

```

或

```
apt-get install -y perl-Time-HiRes

```

**风险**

在没有真正掌握pt-query-digest工具之前，请不要在生产环境就使用pt-query-digest。如果一定要使用，请先做好数据备份、阅读详细的文档以及了解目前已知的BUG。

**使用篇**

现在就可以来使用了，比如我这里有一份mysql的查询日志mysql_query.log，那么就可以通过下面的命令对该日志进行一个粗略的分析。

```
pt-query-degest mysql_query.log

```

Usage

```
pt-query-digest [OPTIONS] [FILES] [DSN]

```

上面只是一个粗略的分析，当然实际当中我们还有许多需求，比如分析具体哪一段时间的日志、或者将分析结果导出来等等的需求。pt-query-digest的众多参数都可以帮我们解决问题。

更多的详细参数信息、processlist以及tcpdump可以点击下方官方给出的文档。

**参考网址**

[pt-query-digest¶](https://www.percona.com/doc/percona-toolkit/2.2/pt-query-digest.html)

[pt-query-digest查询日志分析工具](http://blog.csdn.net/seteor/article/details/24017913)

使用pt-query-digest分析mysql
