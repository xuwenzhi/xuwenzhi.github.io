---
layout: post
title: "PHP扩展开发及入门解惑"
tags: php php-internals extension
---

**说在最前面**

作为PHP程序猿，如果不懂得PHP内核、不懂得PHP扩展开发，仿佛是一件很”羞耻”的事情，嗯，的确很”羞耻”！虽说已经接触PHP已经有三年多的时间了，可是一直都没有机会或者说从没自己主动的去学习过，所以觉得更加”羞耻”了。在这种情况下，如果你被面试官发问说你接触PHP很久的时间有没有学习过PHP底层的知识的时候，你懂的，会更加更加”羞耻”。So，别废话，是该捯饬捯饬PHP扩展了。

**什么是PHP扩展？**

大家在日常的开发过程中或多或少都接触过PHP扩展，比如可以查看OPcode的[vld](https://pecl.php.net/package/vld)扩展，比如性能分析工具[xhprof](http://php.net/manual/zh/book.xhprof.php)，再比如我们经常使用的PDO其实也是以扩展的身份运行于PHP中的(只不过PDO已经是默认编译进PHP源码中，不需要我们另外安装)，所以说PHP扩展离我们并不远。

**为什么要开发PHP扩展？**

- 很重要的点，装X!虽然并不是很务实[偷笑]

- 速度：扩展是用C写的，处理速度要高于PHP不知多少个量级

- 变态的需求：PHP不擅长系统级别的处理，而C可以很容易的实现

**基础知识**

- PHP基础知识牢靠(啥叫牢靠？觉得差不多了就行，最起码会创建个类)

- C基础知识(最起码要理解结构体，链表等概念)

- 一点点操作系统的概念(这个也不强制要求，本人也不在行)

**准备工作**

操作系统 : Centos6.5(只要是Linux就行)

PHP版本 : PHP5.6.9(最好是PHP5.3以后，PHP7之前，毕竟PHP7对内核做了很大的改动)

Note:这里我的PHP环境是lnmp一键安装包搭建的，传送门在此[lnmp一键安装](https://lnmp.org/install.html)

**第一个扩展，就起名叫 myfirstext**

>

在这里先不要管啥啥概念，咱先迅速的走一把，知道扩展大体上是怎么玩的就好。

1.通过PHP提供的ext_skel工具生成扩展的骨架，–extname右边的myfirstext就是扩展的名字

```
~/software/lnmp1.2-full/src/php-5.6.9/ext  ᐅ pwd
/root/software/lnmp1.2-full/src/php-5.6.9/ext
~/software/lnmp1.2-full/src/php-5.6.9/ext  ᐅ ./ext_skel --extname=myfirstext
Creating directory myfirstext
Creating basic files: config.m4 config.w32 .gitignore myfirstext.c php_myfirstext.h CREDITS EXPERIMENTAL tests/001.phpt myfirstext.php [done].
To use your new extension, you will have to execute the following steps:
1.  $ cd ..
2.  $ vi ext/myfirstext/config.m4
3.  $ ./buildconf
4.  $ ./configure --[with|enable]-myfirstext
5.  $ make
6.  $ ./sapi/cli/php -f ext/myfirstext/myfirstext.php
7.  $ vi ext/myfirstext/myfirstext.c
8.  $ make
Repeat steps 3-6 until you are satisfied with ext/myfirstext/config.m4 and
step 6 confirms that your module is compiled into PHP. Then, start writing
code and repeat the last two steps as often as necessary.

```

2.进入myfirstext目录，修改config.m4文件，将下面这段代码前面的dnl删除，我知道你并不想知道这个dnl是干嘛的，但是我还是要说，这个dnl就是注释，编辑好，退出！

```
dnl PHP_ARG_ENABLE(myfirstext, whether to enable myfirstext support,
dnl Make sure that the comment is aligned:
dnl [  --enable-myfirstext           Enable myfirstext support])

```

这个时候，你可以执行下ls，看下这里面大体有哪些文件，我先跟你说啊，这里面比较重要的有myfirstext.c  php_myfirstext.h和myfirstext.php，最最重要的是myfirstext.c，tests文件夹也就是将来我们的测试脚本要写在这里面。

```
~/software/lnmp1.2-full/src/php-5.6.9/ext/myfirstext  ᐅ ls
config.m4   CREDITS       myfirstext.c    php_myfirstext.h
config.w32  EXPERIMENTAL  myfirstext.php  tests

```

3.phpize登场，phpize会根据我们的config.m4配置生成一些编译文件（比如configure等）。

Note:由于我这里是为php5.6.9开发扩展，那尽量要用php5.6.9源码中的phpize，如果你用的和我的PHP版本不一样，那么你可以找到你PHP源码包中的phpize命令，然后执行。

```
~/software/lnmp1.2-full/src/php-5.6.9/ext/myfirstext  ᐅ ../../scripts/phpize
Configuring for:
PHP Api Version:         20131106
Zend Module Api No:      20131226
Zend Extension Api No:   220131226
~/software/lnmp1.2-full/src/php-5.6.9/ext/myfirstext  ᐅ ls
acinclude.m4    config.guess  configure     EXPERIMENTAL     missing         php_myfirstext.h
aclocal.m4      config.h.in   configure.in  install-sh       mkinstalldirs   run-tests.php
autom4te.cache  config.m4     config.w32    ltmain.sh        myfirstext.c    tests
build           config.sub    CREDITS       Makefile.global  myfirstext.php

```

执行完之后，发现多出了好多文件。

4.编译安装三连发

```
~/software/lnmp1.2-full/src/php-5.6.9/ext/myfirstext  ᐅ ./configure
~/software/lnmp1.2-full/src/php-5.6.9/ext/myfirstext  ᐅ make
~/software/lnmp1.2-full/src/php-5.6.9/ext/myfirstext  ᐅ make install
Installing shared extensions:     /usr/lib64/php/modules/

```

Note:如果你编译安装的很顺利，那么忽略这里

./configure报re2c错:执行 yum -y install re2c即可

make报错(/root/software/lnmp1.2-full/src/php-5.6.9/ext/myfirstext/myfirstext.c:146: 错误：‘PHP_FE_END’未声明(不在函数内)) : 打开myfirstext.c，将146行删除并替换为 {NULL, NULL, NULL} 即可。

5.恭喜你已经成功的开发了自己的第一个扩展myfirstext，也就是名字不太好听而已，现在我们验证一下我们的扩展是否可用

找到你的CLI模式下的php.ini(执行命令 php -i | grep php.ini就可以找到，追加一行

```
extension=myfirstext.so

```

重启php，我这里重启php-fpm。执行命令，看到下面这个，就证明你的第一个扩展已经可以正常工作了！可见我们通过扩展新建了一个PHP函数confirm_myfirstext_compiled()。

```
~/software/lnmp1.2-full/src/php-5.6.9/ext/myfirstext  ᐅ php -r 'echo confirm_myfirstext_compiled("Hello World!");'
Congratulations! You have successfully modified ext/myfirstext/config.m4. Module Hello World! is now compiled into PHP.

```

**疑问来了吗？**

好，既然走到了这里，我认为你的第一个PHP扩展也已经开发完毕了。在上面的例子中，我们创建了一个新的PHP内置函数confirm_myfirstext_compiled()，并通过它实现了一个简单的功能，是不是有点不过瘾的感觉呢？不知道你过不过瘾，我是挺过瘾，但对于刚刚开发第一个扩展上也还是充满了诸多的疑问。下面我们将逐步的去解读这些我们都会有的疑问。

**扩展文件夹里面的文件都是用来干嘛的呢？**

在这里，我们将只关注几个文件即可，因为大部分的文件都是工具自动生成出来的。在这里我将这些文件归类。

代码文件:

php_myfirstext.h

myfirstext.c

至于为什么有个.h文件，我想这个你懂的。

扩展配置文件:

config.m4 : *nix下使用

config.w32 : Windows下使用

其他文件，暂时先略过，因为我也不知道。

**最最重要的myfirstext.c文件究竟哪里重要？**

首先，我们先将myfirstext.c文件划分一下区块儿，这样更加直观(因为充满了大量的注释，我在这里并没有列出注释的部分)

```
/**
 * 头文件部分
 */
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "php_myfirstext.h"

static int le_myfirstext;

/**
 * 自定义函数部分，看到该函数的参数还熟吗？这里就是我们上面自定义函数的实现部分！
 */
PHP_FUNCTION(confirm_myfirstext_compiled)
{
    char *arg = NULL;
    int arg_len, len;
    char *strg;

    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC, "s", &arg, &arg_len) == FAILURE) {
        return;
    }

    len = spprintf(&strg, 0, "Congratulations! You have successfully modified ext/%.78s/config.m4. Module %.78s is now        compiled into PHP.", "myfirstext", arg);
    RETURN_STRINGL(strg, len, 0);
}

/**
 * Module初始化和Shutdown部分
 */

PHP_MINIT_FUNCTION(myfirstext)
{
    return SUCCESS;
}

PHP_MSHUTDOWN_FUNCTION(myfirstext)
{
    return SUCCESS;
}

/**
 * Request初始化和shutdown部分
 */
PHP_RINIT_FUNCTION(myfirstext)
{
    return SUCCESS;
}

PHP_RSHUTDOWN_FUNCTION(myfirstext)
{
    return SUCCESS;
}

/**
 * Module Info部分，这里主要控制将扩展信息打印到phpinfo()中
 */
PHP_MINFO_FUNCTION(myfirstext)
{
    php_info_print_table_start();
    php_info_print_table_header(2, "myfirstext support", "enabled");
    php_info_print_table_end();

    /* Remove comments if you have entries in php.ini
    DISPLAY_INI_ENTRIES();
    */
}

/**
 * function_entry部分，这里主要对我们前面自定义的confirm_myfirstext_compiled函数做一个封装
 */
const zend_function_entry myfirstext_functions[] = {
    PHP_FE(confirm_myfirstext_compiled, NULL)       /* For testing, remove later. */
    {NULL, NULL, NULL}
        /* Must be the last line in myfirstext_functions[] */
};

/**
 * module_entry部分，这里应该算是整个文件最重要的部分了吧，属于我们扩展的CPU，这里将会告诉PHP如何初始化我们的扩展。
 */
zend_module_entry myfirstext_module_entry = {
    STANDARD_MODULE_HEADER,
    "myfirstext",
    myfirstext_functions,
    PHP_MINIT(myfirstext),
    PHP_MSHUTDOWN(myfirstext),
    PHP_RINIT(myfirstext),      /* Replace with NULL if there's nothing to do at request start */
    PHP_RSHUTDOWN(myfirstext),  /* Replace with NULL if there's nothing to do at request end */
    PHP_MINFO(myfirstext),
    PHP_MYFIRSTEXT_VERSION,
    STANDARD_MODULE_PROPERTIES
};

#ifdef COMPILE_DL_MYFIRSTEXT
ZEND_GET_MODULE(myfirstext)
#endif

```

所以，最最重要的myfirstext.c中最最基本的这几块儿代码就是这样子的。

**再让我们新建一个函数，名就叫hello_world()吧**

只需要两步，就可以实现我们想要的功能。

1.添加函数定义

```
......
PHP_FUNCTION(confirm_myfirstext_compiled)
{
    char *arg = NULL;
    int arg_len, len;
    char *strg;

    if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC, "s", &arg, &arg_len) == FAILURE) {
        return;
    }

    len = spprintf(&strg, 0, "Congratulations! You have successfully modified ext/%.78s/config.m4. Module %.78s is now        compiled into PHP.", "myfirstext", arg);
    RETURN_STRINGL(strg, len, 0);
}
PHP_FUNCTION(hello_world)
{
    php_printf("hello world!");
}
......

```

2.将hello_world函数添加到function_entry中

```
const zend_function_entry myfirstext_functions[] = {
    PHP_FE(confirm_myfirstext_compiled, NULL)       /* For testing, remove later. */
    PHP_FE(hello_world, NULL)
    {NULL, NULL, NULL}
        /* Must be the last line in myfirstext_functions[] */
};
c
好，再一次编译安装三连发，重启PHP
```bash
~/software/lnmp1.2-full/src/php-5.6.9/ext/myfirstext  ᐅ make install
Installing shared extensions:     /usr/lib64/php/modules/
~/software/lnmp1.2-full/src/php-5.6.9/ext/myfirstext  ᐅ service php-fpm restart
Gracefully shutting down php-fpm . done
Starting php-fpm  done
~/software/lnmp1.2-full/src/php-5.6.9/ext/myfirstext  ᐅ php -r "hello_world();"
hello world!

```

>

当然，上面我们通过PHP官方为我们提供的ext_skel工具直接就创建了一个扩展的骨架，其实我们也可以手动创建。

对于手动创建，我这里就不会去走一把了，您可以直接跳到github学习[walu](https://github.com/walu)大神的开源项目[walu/phpbook](https://github.com/walu/phpbook)，在这里进行系统的学习。本人这些天一直在钻研此教程，并且也有幸获得了walu大神的帮助。

**那么，该如何去看phpbook这个教程呢？我这里做个小分享**

首先请你打开[目录](https://github.com/walu/phpbook/blob/master/preface.md)，会发现目前一共是二十章，而我这几天学习了前13章外加18章，可以保证的是所有的例子都可以得到验证。不仅对于扩展开发的方法及对PHP内核知识的增长也很有益，所以墙裂推荐！

>

如果你觉得在看walu大神的教程有点吃力，可以看我这篇博客[PHP扩展开发相关内核](/php-extension-kernel-concepts)

**关于下面这张大图的说明**

这实际上是我在学习过程中整理出来的Xmind，不保证对你有用。

如果想要拿到Xmind原件，可以点击这里[xuwenzhi/newphpbook](https://github.com/xuwenzhi/newphpbook)

**延伸阅读**

2009年03日 Marcus Börger VS Johannes Schlüter_PHP扩展开发:要特别推荐这个PPT，虽然这个PPT是09年的，但是含金量十足

[TIPI-深入理解PHP内核](http://www.php-internals.com/book/):想要开发好PHP扩展，一定要懂PHP内核

[如何通过C++来开发PHP扩展？](http://www.sitepoint.com/getting-started-php-extension-development-via-php-cpp/)

PHP扩展开发及入门解惑
