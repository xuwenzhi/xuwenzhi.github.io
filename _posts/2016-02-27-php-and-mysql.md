---
layout: post
title: "PHP与MySQL"
tags: php mysql
---

**说在最前面**

	    PHP与MySQL的搭配一直被认为是天生一对，抛开PHP的流行程度，MySQL同样也是世界上最流行的数据库引擎之一，加上之一是因为总得谦虚一点。好，废话也说不出来了，大家都知道，PHP和MySQL的关系也就停留在连接+增删改查+关闭连接就END了，还有什么好说的呢？其实也就是这么回事，和以前接触学过的东西其实没什么两样，大的概念上讲的确就是这么几步，但是我之所以要写一篇这样的文章是因为自从工作后，会发现实际公司做的东西会越来越细致，比如三年前我用php连接MySQL只会mysql_connect()，但是我不知道使用mysql_connect()是一种php与MySQL短连接的方式，而现在我知道竟然有短连接、长连接、持久连接和连接池。另外，三年过去了，mysql_connect()已经在PHP7中被干掉了，如果还使用mysql_connect()是不是会被人笑掉大牙啊，所以就打算为自己整理一个这样的文章吧，希望也能够帮到需要的朋友。

	**mysql扩展已经被干掉啦**

>

		mysql extension was deprecated in PHP 5.5.0, and it was removed in PHP 7.0.0. Instead, the [MySQLi](file:///Users/azxuwen/Library/Application%20Support/Dash/DocSets/PHP/PHP.docset/Contents/Resources/Documents/php.net/manual/en/book.mysqli.html) or [PDO_MySQL](file:///Users/azxuwen/Library/Application%20Support/Dash/DocSets/PHP/PHP.docset/Contents/Resources/Documents/php.net/manual/en/ref.pdo-mysql.html) extension should be used


	是的，就是这么回事。

	**MySQLI和PDO我该选择哪一种？**

	[PDO vs. MySQLi 选择哪一个？(PDO vs. MySQLi: Which Should You Use?)](http://blog.csdn.net/yipiankongbai/article/details/17277477)

	看完这个，我相信你会给MySQLI打10分，剩下的90分打给PDO。

	**PHP与MySQL的连接**

	**短连接** : 正常的php框架一般都使用短连接，也就是当脚本执行完毕后，默认关闭连接

	连接-》数据传输-》关闭连接；

	**长连接** : 类似于socket连接，长时间保持mysql server和某个client的连接状态

	连接-》数据传输-》保持连接-》数据传输-》保持连接-》…………-》关闭连接；

//早期mysql实现长连接，在PHP7被废弃

[mysql_pconnect](http://www.php.net/mysql_pconnect)()

//mysqli实现长连接

$conn = new mysqli('p:'.$this->host, $this->user, $this->pwd, $this->db);

//PDO实现长连接

$conn = new PDO($dsn, DB_USER, DB_PASSWORD, [array](http://www.php.net/array)(PDO::ATTR_PERSISTENT => true) );

	**持久连接** : 永久的数据库连接是指在脚本结束运行时不关闭的连接。当收到一个永久连接的请求时。PHP 将检查是否已经存在一个（前面已经开启的）相同（是指用相 同的用户名和密码到相同主机的连接）的永久连接。如果存在，直接复用；如果不存在，则建立一个新的连接。 对web服务器的工作和分布负载没有完全理解的读者可能会错误地理解永久连接的作用。

	不建议使用这种连接 : 永久连接不会在相同的连接上提供建立“用户会话”的能力，也不提供有效建立事务的能力。实际上，从严格意义上来讲，永久连接不会提供任何非永久连接无法提供的特殊功能。

	**连接池** : 连接池的概念其实不难理解，在这里主要存在一个线程池来完成与MySQL连接的操作。

	小故事 : 假如有一个包工头，他接了个搬砖的活儿，于是鼓动众兄弟一起干这一票。中午时分，每个兄弟开始在工地奋斗起来，众兄弟非常勤劳，不一会儿砖就搬完了，这时包工头觉得现在不太忙告诉小a和小b“现在不那么忙了你们回去睡个午觉吧”，剩下的人留守在这里。到了晚上一下来了十车砖，这时包工头发现眼前这个队伍貌似有点不太够用，于是乎快速招聘了几个人来帮忙，大家干的很起劲，不一会儿就干完了。

	分析下我们的小故事，做个简单的映射。故事中 搬砖工人对应计算机中的线程，包工头对应操作系统，而搬砖这项工作可以映射为连接MySQL这个行为。而在我们实际运营网站的过程中，会有流量正常期，高流量峰期和流量低峰期。MySQL线程池会合理安排线程的数量，以应对不同时期，当高峰期时，MySQL线程池会创建一些线程来帮忙（类似于故事中的招聘），在低峰期时，MySQL线程池可能会销毁一些线程(告诉小a和小b回去睡个午觉吧)。线程池在这其中做一个平衡，以保证php或其他能够正常连接到MySQL，防止在高并发时过多的连接压垮MySQL，保证MySQL的稳定性，对于更加详细的连接池原理可以看这里[数据库连接池的工作原理](http://www.cnblogs.com/newpanderking/p/3875749.html)

	那么如何配置PHP与MySQL连接池呢？ 换句话说，如何保证PHP与MySQL的连接是以连接池的方式连接呢？这个概念还稍显复杂，为什么这么说呢？因为在PHP本身是不支持多线程的，当然可以使用PHP多线程扩展来实现我们的功能，但在PHP层面来实现这个功能还稍显复杂且稳定性极差。目前的基本做法是使用ODBC，且这和PHP语言本身没有什么关系，而是在MySQL与操作系统层面来实现的连接池。而实际场景中比较常见的做法是使用第三方的Proxy，市面上有很多这样的MySQL代理。比如搜狐的数据库中间件[DBProxy](https://github.com/SOHUDBA/SOHU-DBProxy)，还有MySQL官方的[MySQL Proxy](http://dev.mysql.com/doc/mysql-proxy/en/)。

	延伸阅读：

	 [C实现PHP的mysql数据库连接池](http://blog.csdn.net/a600423444/article/details/8835801) ：如果有c和php扩展开发经验可以尝试一下

	**PHP与数据库(MySQL，Oracle，SqlServer.etc)的连接抽象层**

	细心的你注意到了，标题中我列了好多种数据库，So，这里并不会局限在MySQL上。

	大多数框架为我们提供了PDO连接的抽象层，也就是在PDO的基础上搭建的一层，比如连接操作。在这里主要列举了常用而且比较流行的PDO基础上的抽象层。

-
		[Aura SQL](https://github.com/auraphp/Aura.Sql)


-
		[Doctrine2 DBAL](http://www.doctrine-project.org/projects/dbal.html)


-
		[Propel](http://propelorm.org/)


	**总结**

	未完待续。

	 

	 

PHP与MySQL
