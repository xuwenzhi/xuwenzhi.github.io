---
layout: post
title: PHP Realpath Cache.
tags: php internal
---


# realpath_cache: the true culprit

When we use include/require functions or autoload, we should consider realpath_cache. Realpath Cache is a PHP feature for caching file and folder paths, designed to minimize file disk IO.

<!-- more -->

# Brief

Introduced in PHP 5.1.0, there's still not much official documentation to this day, such as realpath\_cache\_get(), realpath\_cache\_size(), clearstatcache() and realpath\_cache\_size and realpath\_cache\_ttl in php.ini. An older article with an introduction can be found at [http://blog.jpauli.tech/2014/06/30/realpath-cache.html](http://blog.jpauli.tech/2014/06/30/realpath-cache.html).


# Background

When we access a file, PHP uses the Unix system command **stat()** to process its path, which returns the file's inode.

PHP calls this the realpath\_cache\_bucket (not including permissions and owner information), so if we try to access the same file twice, it saves one bucket lookup.

For deeper content, you can check the PHP source code at [https://github.com/php/php-src/blob/php-7.0.0/Zend/zend_virtual_cwd.c](https://github.com/php/php-src/blob/php-7.0.0/Zend/zend_virtual_cwd.c)

# realpath_cache_get()

The realpath\_cache\_get function was introduced in PHP 5.3.2. It returns all cached real paths, similar to the following:

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
);
```
- key is a floating-point number representing the hash associated with the path
- is_dir is a boolean; true when the path is a directory
- realpath is the path of the file/directory
- expires is a number representing when the path cache expires, obtainable via realpath_cache_ttl

In the path example above, **/var/www/current/index.php** is special; other paths are all associated with it. That is, this one path is divided into multiple parts. In this example, the actual path is /var/www/html/release1/index.php because /var/www/current is symlinked to /var/www/html/release1.

> The realpath cache is process bound, and not shared into shared memory

> because the realpath cache is stored on the process level not in shared memory like Opcache.


This means this cache must expire in each FPM process or when the process dies. So if using PHP-FPM to handle requests, you need to wait for all PHP-FPM child process caches to expire. This is very useful for understanding the production-no-cache configuration, where even after symlink switching and OPCache is disabled, there's a time lag before PHP notices the real path change.

So we need to adjust the impact of real path, such as the parameters realpath_cache_size and realpath_cache_ttl. If our web application has a considerable number of files, we need to increase realpath\_cache\_size. Additionally, realpath\_cache\_ttl represents the cache time for realpath.

To disable realpath cache, you can set:

```
realpath_cache_size=0k
realpath_cache_ttl=-1
```

# Reference

[https://engineering.facile.it/blog/eng/realpath-cache-is-it-all-php-opcache-s-fault/](https://engineering.facile.it/blog/eng/realpath-cache-is-it-all-php-opcache-s-fault/)
