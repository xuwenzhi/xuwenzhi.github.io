---
layout: post
title: PHP Realpath Cache.
tags: php internal
---


# realpath_cache: the true culprit

当我们使用include/require函数或者autoload时，我们应该考虑realpath_cache。Realpath Cache是PHP针对文件和文件夹的路径缓存的特性，为了能够最小化文件磁盘IO。

<!-- more -->

# brief 

PHP5.1.0时提出，到目前为止官方文档也没有太多介绍，比如realpath\_cache\_get(), realpath\_cache\_size(), clearstatcache()和php.ini中的realpath\_cache\_size和realpath\_cache\_ttl。能够找到一篇老文章有介绍[http://blog.jpauli.tech/2014/06/30/realpath-cache.html](http://blog.jpauli.tech/2014/06/30/realpath-cache.html)。


# background

当我们访问一个文件时，PHP使用Unix系统命令 **stat()** 处理它的路径，它会返回文件的inode。
  
PHP将它称为realpath\_cache\_bucket（不包含权限和所有者等信息），所以如果我们尝试访问相同文件两次的话，将会省去一次bucket查找。

如果希望看到更深层次的内容，可以查看PHP源码[https://github.com/php/php-src/blob/php-7.0.0/Zend/zend_virtual_cwd.c](https://github.com/php/php-src/blob/php-7.0.0/Zend/zend_virtual_cwd.c)

# realpath_cache_get()

realpath\_cache\_get这个函数上在PHP5.3.2介绍的，它会返回所有缓存的真实路径，类似于下面这样

```
Array
(
    [/var/www/html] => Array
        (
            [key] => 1438560323331296433
            [is_dir] => 1
            [realpath] => /var/www/html
            [expires] => 1504549899
        )
    [/var/www] => Array
        (
            [key] => 1.5408950988325E+19
            [is_dir] => 1
            [realpath] => /var/www
            [expires] => 1504549899
        )
    [/var] => Array
        (
            [key] => 1.6710127960665E+19
            [is_dir] => 1
            [realpath] => /var
            [expires] => 1504549899
        )
    [/var/www/html/release1] => Array
        (
            [key] => 7631224517412515240
            [is_dir] => 1
            [realpath] => /var/www/html/release1
            [expires] => 1504549899
        )
    [/var/www/current] => Array
        (
            [key] => 1.7062595747834E+19
            [is_dir] => 1
            [realpath] => /var/www/html/release1
            [expires] => 1504549899
        )
    [/var/www/current/index.php] => Array
        (
            [key] => 6899135167081162414
            [is_dir] => 0
            [realpath] => /var/www/html/release1/index.php
            [expires] => 1504549899
        )
)；
```
- key 是一个浮点数，代表与路径相关的hash散列
- is_dir 是一个布尔型，当路径为文件夹，则为true
- realpath 是文件/文件夹的路径
- expires 是一个数字，它代表了路径缓存过期的时间，可以通过realpath_cache_ttl获取

在前面的路径例子中，**/var/www/current/index.php** 是很特殊的，其他的路径均与它有关联。也就是这一个路径被分为多个部分。这个例子中真正的路径是/var/www/html/release1/index.php，因为/var/www/current是软链到/var/www/html/release1这里的。

> The realpath cache is process bound, and not shared into shared memory

> because the realpath cache is stored on the process level not in shared memory like Opcache.


意味着这个缓存必须在每一个FPM进程过期或进程死掉，所以如果使用到了PHP-FPM来处理请求，需要等到PHP-FPM的所有子进程的缓存过期，这对于我们理解这个配置production-no-cache是很有用的，即使在软链切换之后OPCache禁用，PHP注意到real path发生变化是有时差的。

所以，我们需要调整real path带来的影响，比如以下的这些参数 realpath_cache_size和 realpath_cache_ttl。如果我们的Web应用有相当大数量的文件，我们需要增大realpath\_cache\_size，另外的realpath\_cache\_ttl，代表了realpath的缓存时间。

如果需要禁用realpath cache，可以这样设置:

```
realpath_cache_size=0k
realpath_cache_ttl=-1
```

# refer

[https://engineering.facile.it/blog/eng/realpath-cache-is-it-all-php-opcache-s-fault/](https://engineering.facile.it/blog/eng/realpath-cache-is-it-all-php-opcache-s-fault/)
