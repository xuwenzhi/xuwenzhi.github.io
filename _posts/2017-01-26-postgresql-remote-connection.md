---
layout: post
title: "PostgreSQL允许远程连接的套路"
tags: postgresql database
---

最近在弄ruby-china的homeland，所以自然又接触到了一种新的数据库，叫做[PostgreSQL](https://www.postgresql.org/)，也是一种存在了很多年的关系型数据库，上手起来也不是太难，本次文章主要介绍如何在本地连接远端的PostgreSQL数据库的方法，关于如何安装，请看这里[How to Install PostgreSQL 9.5 on CentOS/RHEL 7/6/5 and Fedora 23/22](http://tecadmin.net/install-postgresql-9-5-on-centos/)

**运行环境**

远端机器系统 : CentOS6.5

远端机器IP : 192.168.33.10

远端PostgreSQL : 9.5

本地机器系统 : MacOS

本地机器IP : 192.168.33.1

本地客户端软件 : [PG Commander](http://eggerapps.at/pgcommander/)

**进入正题**

走到这里，我认为你的PostgreSQL和PG Commander已经安装完成了。

打开PG Commander，会是如下这种界面

如图所见，我们需要准备的有主机IP、端口、用户名以及用户名的密码，还有需要连接的数据库，接下来我们就要把这些东西准备好。

设置PostgreSQL的用户名和密码

因为PostgreSQL在安装初始化后就会存在一个账户 postgres ，可以称之为叫做超管的账户，我们现在需要做的是修改这个账号的密码。

```
sudo su # 切换到 root 账号
su - postgres # 切换到 postgres 账号
psql # 进入 postgresql 工作台
alter user postgres with password '你的密码'; # 执行此命令修改成你的密码
\q # 退出工作台

```

至此，我们的用户名和密码就已经准备完毕了。

设置PostgreSQL允许远程连接

使用 sudo find / -name postgresql.conf 找到此文件，然后编辑它，比如我的postgresql.conf在 /var/lib/pgsql/9.5/data/postgresql.conf 下，添加如下两行

```
listen_addresses = '*' # 设置PostgreSQL允许访问的客户端IP
port = 5432            # 设置PostgreSQL监听的端口

```

使用 sudo find / -name pg_hba.conf 找到此文件，然后编辑它，比如我的pg_hba.conf在/var/lib/pgsql/9.5/data/pg_hba.conf 下，修改的地方如下，将IPv4连接的地方，设置成允许192.168.33.1访问，这个IP是我们本地的IP(你的可能会不同)，最后的 md5 意思是使用用户名和密码的方式登录。

```
# IPv4 local connections:
host    all             all             192.168.33.1/32         md5

```

最后，重启 PostgreSQL（还是讲一句，你的重启方式可能会和我不一样）

```
sudo service postgresql-9.5 restart

```

使用PG Commander连接 PostgreSQL

至此，也就是连接成功了！

PostgreSQL允许远程连接的套路
