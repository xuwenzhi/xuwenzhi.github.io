---
layout: post
title: "Laravel之PHPUnit问题篇"
tags: php laravel phpunit testing
---

昨晚讨论了一下Laravel的PHPUnit相关的内容Laravel之PHPUnit，主要是做了个入门讨论，由于篇幅有限，所以有些额外需要补充的内容或者有一些注意点就在这里搞一下。

**测试之前确保配置清空**

>

but make sure to clear your configuration cache using the config:clear Artisan command before running your tests!

来自官方的说明，意为在测试前需要清空配置缓存，测试前执行如下命令

```
php artisan config:clear

```

为了不是每次都要清空配置缓存，一劳永逸的做法是，修改.env配置文件，修改CACHE_DRIVER为array（建议开发环境就将此配置设置为array）

```
CACHE_DRIVER=array

```

**连续$this->call();**

当我们写一个测试用例时经常会有这样的情况，比如我们做了个新建数据的测试，然而这个新建的数据可能会为垃圾数据，所以这时我们可能会再次请求删除接口将刚刚新建的数据删除，所以这时就涉及到2次或者多次GET/POST请求，而这时可能会引发一些问题，需要在每次发起请求后都需要刷新一下当前的测试上下文才行，具体做法是，每次请求后调用refreshApplication()。

```
$this->call();

$this->refreshApplication();//刷新应用上下文

$this->call();

```

**阻止EncryptCookies对cookie解密**

由于Laravel内置的Cookie类方法会对cookie值进行加密解密，而有时候不希望Laravel将我们请求时携带的cookie进行解密的，比如有时候这个cookie是JavaScript生成的或者直接使用setcookie()来创建cookie(这时的cookie是没有经过加密的)，这时如果我们通过Cookie::get()来拿到cookie的话会导致这个值被无故解密一次，这时的cookie值就不对了，那么如何在编写测试用例时阻止cookie被解密？则可以通过在app/Http/Middleware/EncryptCookies.php中添加isDisabled()方法，通过重写isDisabled方法来解决这个问题。

```
    /**
     * Determine whether encryption has been disabled for the given cookie.
     *
     * @param  string $name
     * @return bool
     */
    public function isDisabled($name)
    {
        if(\App::environment() === 'testing'){
            return true;
        }
        return in_array($name, $this->except);
    }

```

**综上**

暂时整理了这些问题，未完待续。

Laravel之PHPUnit问题篇
