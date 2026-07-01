---
layout: post
title: "使用Vagrant+VirtualBox十分钟内部署环境(附.box文件)"
tags: vagrant virtualbox devops
---

*本文适合于Mac，Windows版本不保证可以运行成功。*

如果你还在花费大量的时间搭开发环境，如果你还因花费大量的精力去在一台机器上安装各种PHP版本而苦恼，如果你是一名QA，因为测试环境的种种问题影响效率，在比较朴素的办法上Vagrant值得你拥有，虽然Docker已经风生水起了，但是朴素的办法还是Vagrant，稳定性好。因为最近吃了不少Docker的坑。

那么Vagrant到底是做什么的？简单来讲是一种管理虚拟机的工具，当然如果不使用Vagrant，直接使用虚拟机同样也可以运行各种环境，但是如果你使用Vagrant，绝对会提升你不知道多少量级的体验。

在这里附上一个我本人制作的.box文件，什么是.box文件呢？说白了这个.box文件其实就是操作系统，在Vagrant里，Vagrant可以将.box系统轻巧地注入到虚拟机中，也可以很方便的在把虚拟机导出成为一个.box，而导出的这个.box文件还可以继续拿给你同事用。

这会让你省下很多时间来搞开发环境，关于这个我的这个.box文件的详细信息看下面

所有服务均安装在work账户下，安装的服务有:

- centos6.5

- nginx1.8.1

- php5.6

- redis

- mysql(暂时未装)

所以比较适合PHP开发者。点击[这里下载](http://pan.baidu.com/s/1pKOCJer)我的.box文件。如果你觉得不想用我这个.box也可以到[A list of base boxes](http://www.vagrantbox.es/)下载你想要安装的操作系统，下载完之后，就会得到一个.box文件，比如我的叫做lnmp_package.box。

**准备工作：**

安装Vagrant和VirtualBox这两个软件，关于这两个软件的安装，这里就不在赘述，我在这里等待你安装成功。

OK，我假设你已经安装好了Vagrant和VirtualBox，打开的你的终端。

**将box注入虚拟机**

1.将lnmp_package.box添加到自己的vagrant box list中(test-dev这个名称随你的喜好起名)

```
vagrant box add test-dev ~/Destop/lnmp_package.box

```

2.新建一个文件夹，比如在家目录~下创建test，用于作为虚拟机的入口文件夹，相关的虚拟机配置也在这里，在文件夹中执行命令

```
vagrant init test-dev

```

3.编辑Vagrantfile，将此行的注释去掉，也就是说下面这个ip地址将作为将来我们和虚拟机通讯的ip。

```
config.vm.network "private_network", ip: "192.168.33.10"

```

4.启动虚拟机

```
vagrant up

```

5.登录虚拟机

```
vagrant ssh

```

如果你已经顺利登录上去了，那就已经OK了。当然，你可以在此基础上对虚拟机进行改进，比如修改一些系统参数，系统调优等工作，而现在你也可以生成.box文件发给你的同事。

```
vagrant package

```

使用Vagrant+VirtualBox十分钟内部署环境(附.box文件)
