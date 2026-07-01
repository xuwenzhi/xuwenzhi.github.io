---
layout: post
title: "PHP安全技术"
tags: php security
---

**安全技术基础知识**
1、如果被提交的数据需要在Web页面上从新显示，则需要通过strip_tags()函数来清楚HTML和潜在的Javascript。
2、不要在Web站点上暴露PHP错误信息，有事黑客正是通过破坏来获取漏洞。
3、防止Sql注入，可以使用mysqli_real_escape_data()，确保提交的内容不会破坏查询。
4、永远不要在服务器上保存phpinfo()脚本，这样很危险，真的很危险。

**检验表单数据**
**①一些简单的表单验证函数**
1、使用checkdate()函数确保指定数据的有效性
2、对数字进行类型转换
3、使用正则表达式检查电子邮件地址、url、和其他具有可定义式样的内容

      字符型函数

                     检查参数里是否包含

ctype_alnum()

字母和数字

ctype_alpha()

字母

ctype_cntrl()

控制字符

ctype_digit()

数字

ctype_graph()

可打印字符，空格除外

 ctype_lower()

                                   小写字母

ctype_print()

可打印字符

ctype_punct()

标点符号

ctype_space()

空白字符

ctype_upper()

大写字母

ctype_xdigit()

十六进制数

**②使用PECL过滤器**
**PECL代码的Filter(过滤器)库是PHP5里新增加的。**

**filter_input(‘变量源’， ‘变量名称’，’验证类型’  ，【其他】)**
**变量源   **主要是针对例如 INPUT_POST, INPUT_GET, INPUT_SERVER, INPUT_SESSION, INPUT_ENV, INPUT_COOKIE….
**变量名称     **主要是例如表单中的需要进行验证的name值…
**验证类型     **主要是Filter提供了一些简单的验证类型，详情可以看php手册
**其他        **主要是例如如果进行整数验证，可以约束整数的上限或者下限

**可以通过添加第四个参数来去掉html标签**

**使用MCrypt加密技术**
**Mcrypt支持的算法有：**

- cast-128

- gost

- rijndael-128

- twofish

- arcfour

- cast-256

- loki97

- rijndael-192

- saferplus

- wake

- blowfish-compat

- des

- rijndael-256

- serpent

- xtea

- blowfish

- enigma

- rc2

- tripledes

**Mcrypt支持的加密模式有：[对称加密和分组加密中的四种模式(ECB、CBC、CFB、OFB)](http://www.cnblogs.com/happyhippy/archive/2006/12/23/601353.html)**

- cbc

- cfb

- ctr

- ecb

- ncfb

- nofb

- ofb

- stream

**Wamp下MCrypt安装方法**

- 打开 php.ini，搜索找到“**;**extension=php_mcrypt.dll”, 把这行最前面的 ; 去掉，保存。

- 打开php目录，把libmcrypt.dll复制到 %system%/system32  目录（如：xp系统的话是c:\windows\system32\里。

- 重启wamp即可

**使用方法**
**加密**

- **创建密钥**

- **指定加密算法和加密模式，也就是创建加密描述**

- **创建加密向量**

- **初始化**

- **执行加密**

- **关闭加密句柄**

<?php
$key = md5(‘azxuwen701’);//密钥
$data = ‘徐文志’;//加密数据

$m = mcrypt_module_open(‘rijndael-256’, ”, ‘cbc’, ”);//使用Rijndael 256加密算法 和 使用’cbc’的加密模式
/*
 返回值 Normally it returns an encryption descriptor, or FALSE on error 叫做一个加密的描述
  第一个参数 : 指定加密算法
 第二个参数 : 加密算法的所在路径
 第三个参数 : 加密模式
 第四个参数 : 加密模式所在路径
*/
$iv = mcrypt_create_iv(mcrypt_enc_get_iv_size($m), MCRYPT_RAND);// 初始化向量 创建Vector 第一个参数指定向量的size 第二个参数里设置一个随机资源
/*
 $m为一个加密描述
 要用到这个描述来生成向量，mcrypt_enc_get_iv_size($m) 获取到这个向量的size
*/

mcrypt_generic_init($m, $key, $iv);//初始化加密,也就是如果想进入加密的屋子就必须要先有钥匙，而这个函数提供这个钥匙
/*
 返回值为 int
 第一个参数 : 加密描述
 第二个参数 : 秘钥
 第三个参数 : 加密向量
*/
$data = mcrypt_generic($m, $data);//执行加密
/*
 返回值肯定是加密后数据
 第一个参数 : 加密描述
 第二个参数 : 需要加密的数据
*/

echo “直接输出\$data {$data}”;
echo “<br/>再使用base64加密后的\$data “.base64_encode($data);

//关闭句柄
mcrypt_generic_deinit($m);
mcrypt_module_close($m);//这个与mcrypt_module_open()相对应
?>

**解密**

- 创建密钥 (注意和加密时的密钥必须一致)  $key

- 确定加密算法和加密描述，必须要和加密时一致 $m

- 确定加密向量，必须要和加密是一直  $iv ,实际上这个$iv也是一个加密的字符串并且是随机的，如何能在两个页面之间来传递这个$iv，需要想办法，比如COOKIE

- 通过mdecrypt_generic($m, $data)执行解密，返回的是明文

<?php
$key = md5(‘azxuwen701’);//密钥
$m = mcrypt_module_open(‘rijndael-256’, ”, ‘cbc’, ”);//使用Rijndael 256加密算法 和 使用’cbc’的加密模式
$iv = base64_decode($_COOKIE[‘thing2’]);
/*
cookie变量保存着加密时的向量，这个加密向量是需要在页面之间进行传递的
*/

mcrypt_generic_init($m, $key, $iv);//初始化加密,也就是如果想进入加密的屋子就必须要先有钥匙，而这个函数提供这个钥匙
//数据解密
$data = mdecrypt_generic($m, base64_decode($_COOKIE[‘thing1’]));
/*
 函数中的Cookie是保存在浏览器中的cookie，它实际上是要解密的暗文
*/

echo “加密之前的明文是 : “.$data;
?>

****提示 :****

**①**** 实际上MCrypt能够实现数据解密的原因就是它在执行解密的时候，依旧使用的是加密时的初始向量$iv**

**② 注意加密后的密文中如果存在 ****+ ，那么在解密回去的时候就需要注意了**

**为什么文件上传表单是主要的安全威胁？**
**1、如上传图片时**
    PHP中存在一个函数，用于检查图片的头信息，**getimagesize()**
****    如果是正确的图片信息，返回true 反之返回false****

**    可能出现的问题 : **如果一个恶意用户试着上传一个内嵌有简单 PHP shell 的 jpg 文件的话, 该函数会返回 false 然后他将不允许上传此文件. 然而, 即使这种方式也能被很容易的绕过. 如果一个图片在一个图片编辑器内打开, 就如 Gimp, 用户就可以编辑图片的注释区, 那儿就能插入 PHP 代码

就如下图所示.

该图片仍然有一个有效的头部; 因此就绕过了 **getimagesize** 函数的检查. 从下面截图中可以看到, 当一个普通的 web 浏览器请求该图的时候, 插入到图片注释区的 PHP 代码仍然被执行了:

 

PHP安全技术
