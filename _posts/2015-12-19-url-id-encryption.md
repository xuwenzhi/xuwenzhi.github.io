---
layout: post
title: "url中id加密解密"
tags: php security
---

```
xxx.com/order_id=888
xxx.com/order/888

```

我们通常不喜欢在URL中出现上面这些URL，因为存放在我们数据库表中的主键ID正暴露在用户甚至黑客的面前，这是一件非常危险的事，所以我们通常的做法找到一个可以双向加密的算法对URL中的ID能够加密解密。

以下列了几种方法或者称为算法。

**1.使用AES128的算法（使用mcrypt扩展实现）**

```
<?php
class Aes
{
    const ID_CRYPT_KEY = 'zheshiyigemiyue';//密钥
    public static function xcryptEncode($id = 0){
        $iv = mcrypt_create_iv(mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256, MCRYPT_MODE_ECB), MCRYPT_RAND);
        $data = mcrypt_encrypt(MCRYPT_RIJNDAEL_128, md5(self::ID_CRYPT_KEY), $id, MCRYPT_MODE_ECB, $iv);
        $data = base64_encode($data);
        //将/替换成-，原因在于生成的密文中存在/，会与pathinfo中的/冲突
        $data = str_replace('/', '-', $data);
        return $data;
    }

    public static function xcryptDecode($cipher_id = ''){
        $cipher_id = str_replace('-', '/', $cipher_id);
        return mcrypt_decrypt(MCRYPT_RIJNDAEL_128, md5(self::ID_CRYPT_KEY), base64_decode($cipher_id), MCRYPT_MODE_ECB, mcrypt_create_iv(mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256, MCRYPT_MODE_ECB), MCRYPT_RAND));
    }

}
$id = 10;
$cipher_id = Aes::xcryptEncode($id);
echo "原ID是:".$id;
echo "加密后:".$cipher_id;
echo "解密后:".Aes::xcryptDecode($cipher_id);

```

说明：

①需要安装mcrypt扩展

②生成的密文有点长，所以如果你不喜欢这种密文，可以考虑下一种

③我个人自测了1-10w的数字没有重复率现象，绝对可用

**2.一个国外的哥们儿模仿YouTube的URL的算法**

传送门网址 : [http://kvz.io/blog/2009/06/10/create-short-ids-with-php-like-youtube-or-tinyurl/](http://kvz.io/blog/2009/06/10/create-short-ids-with-php-like-youtube-or-tinyurl/)

说明：

①经得起考验：当时写[PP校园](http://ppxiaoyuan.com)时，正是使用了他这个算法进行ID的加密解密

②好看一些：加密的密文会随着ID的增大越来越长越来越复杂，而且较上一种还是挺好看的

③各种语言支持：不光有PHP版的，还有Java、Python、javascript、C#和Go的等等版本。

url中id加密解密
