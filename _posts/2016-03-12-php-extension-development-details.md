---
layout: post
title: "PHP扩展开发之细枝末节"
tags: php php-internals extension
---

**ZTS(Zend Thread Safety)**

当要使用Zend线程安全(Zend Thread Safety)时，需要在configure时，使用–enable-maintainer-zts参数，这种情况下，就会定义这个名为ZTS的宏。同时在处理PHP内置数据时，需要在函数调用时的最后一个参数后使用TSRMLS_XX标记。

TSRMLS_XX一般有4种形式，关于何时该使用哪一个，看下面这里

TSRMLS_D  in declarations as only param

TSRMLS_C  in uses (calls) as only param

static void my_helper(TSRMLS_D);

    static void some_function(TSRMLS_D) {

    my_helper(TSRMLS_C);

}

TSRMLS_DC in declarations after last param w/o comma

TSRMLS_CC in uses after last param w/o comma

static void my_helper(void * p TSRMLS_DC);

    static void some_function(void * p TSRMLS_DC) {

    my_helper(p TSRMLS_CC);

}

**ArgInfo**

是一种特殊的结构体，用来提前向内核告知此函数具有的一些特定的性质，比如其将告诉内核本函数需要引用形式的返回值，所以内核不再通过return_value来获取执行结果，而是通过return_value_ptr。如果没有arginfo，那内核会预先把return_value_ptr置为NULL，当我们对其调用zval_ptr_dtor()函数时便会使程序崩溃。

#if (PHP_MAJOR_VERSION > 5) || (PHP_MAJOR_VERSION == 5 && PHP_MINOR_VERSION > 0)

    ZEND_BEGIN_ARG_INFO_EX(return_by_ref_arginfo, 0, 1, 0)

    ZEND_END_ARG_INFO ()

#endif /* PHP >= 5.1.0 */

然后使用下面的代码来申明我们的定义的函数：

#if (PHP_MAJOR_VERSION > 5) || (PHP_MAJOR_VERSION == 5 && PHP_MINOR_VERSION > 0)

    ZEND_FE(return_by_ref, return_by_ref_arginfo)

#endif /* PHP >= 5.1.0 */

**扩展函数内部的设计规则**

PHP_FUNCTION(yourext_name) {

    /* Local declarations */

    /* Parameter parsing */

    /* Actual code */

    /* Return value */

}

**扩展函数注意事项**

- 函数输出不要使用stdout标准流输出，禁止使用printf()，要使用PHP的php_printf()和PHPWRITE()。PHPWRITE()保证二进制安全

- 数据格式化 使用snprintf()或者spprintf()，不要使用sprintf()

…..未完…..

PHP扩展开发之细枝末节
