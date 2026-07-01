---
layout: post
title: "构建自己的composer包"
tags: php composer
---

随着Composer这个包管理工具越来越流行，大家在安装一些开源项目的时候，经常会在github上看到一些知名的PHP开源项目使用composer的方式来安装，那么如何把自己认为比较不错的项目也构建成composer包呢？

    好，下面开始走起~~

**准备阶段**

1.首先在github上create一个仓库命名为[miniUpload](https://github.com/xuwenzhi/miniUpload)

2.回到命令行，然后把项目clone下来，并cd到miniUpload

```
git clone https://github.com/xuwenzhi/miniUpload.git

cd miniUpload

```

3.好，composer登场，执行如下命令，用composer初始化一下该目录

```
composer init

```

然而，我在执行过程中遇到了如下错误，原因在于我的PHP配置中禁用了某些函数，而composer需要使用这些函数，所以报错了。

解决方案：打开你的php.ini，找到disable_functions那一行，将图中的proc_open删掉即可。

4.好，继续composer init，还没完事，它问你问题了

```
//填写你的包名，注意这个包名要和右侧中[root/mini-upload]一致，比如我填写的是 xuwenzhi/miniupload
Package name (<vendor>/<name>) [root/mini-upload]:xuwenzhi/miniupload
//填写你的包的描述
Description []: A simple and mini PHP upload class.
//填写作者信息
Author [xuwenzhi <358350782@qq.com>]: xuwenzhi <358350782@qq.com>
//填写你的包当前的稳定状态，不填写直接回车或者填写可选值（stable, RC, beta, alpha, dev）
Minimum Stability []: dev
//包类型和协议直接回车就好了
Package Type []:
License []: MIT
//填写你的包的依赖，比如最低要求PHP的哪个版本啊之类的，在这里表示依赖PHP5.3及以上版本
Define your dependencies.

Would you like to define your dependencies (require) interactively [yes]? yes
Search for a package: php
Enter the version constraint to require (or leave blank to use the latest version): >=5.3
Search for a package:
Would you like to define your dev dependencies (require-dev) interactively [yes]? no

//这样就生成了这样的composer.json文件
{
    "name": "xuwenzhi/miniupload",
    "description": "A simple and mini PHP upload class.",
    "license":"MIT",
    "require": {
        "php": ">=5.3"
    },
    "authors": [
        {
            "name": "xuwenzhi",
            "email": "358350782@qq.com"
        }
    ],
    "minimum-stability": "dev"
}
//如果确认就可以输入yes，并回车
Do you confirm generation [yes]? yes
//最后问一下是否要将composer生成的vendor目录添加到.gitignore,输入yes并回车即可
Would you like the vendor directory added to your .gitignore [yes]? yes

```

现在会发现项目目录下面出现了个composer.json文件，这样基本的composer外壳就算完成了。

**动手阶段**

    虽然我们已经构建出一个composer外壳，但是它现在还是个空壳子，并没有内涵，所以接下来的工作我们需要不断地丰富它的内涵。

1.vim打开composer.json，编辑成如下模样。在这里只是增加了autoload那一块，也就是说我们使用psr-4的方式来将我的MiniUpload类autoload，，在这里我定义了命名空间为MiniUpload，并映射到的目录为./src/目录下。

```
{
    "name": "xuwenzhi/miniupload",
    "description": "A simple and mini PHP upload class.",
    "license":"MIT",
    "require": {
        "php": "5.3"
    },
    "authors": [
        {
            "name": "xuwenzhi",
            "email": "358350782@qq.com"
        }
    ],
    "minimum-stability": "dev",
    "autoload": {
        "psr-4": {
            "MiniUpload\\": "src/"
        }
    }
}

```

2.准备工作已经完成，但你或许会有疑惑，上面的那个vendor用来干嘛的？

    用我自己的话来讲，vendor目录其实就是一个大池子，里面放了好多开源包供我们使用，比如当我们需要使用一个对图片切割的包，我们通过composer install的方式将图片切割包下载下来，就会自动归入vendor目录下，这样也方便了对包的管理。

3.下面才是真正的开始

```
composer install

```

执行完之后，发现那个神奇的vendor出现了。

打开vendor/composer/autoload_psr4.php，看看是不是MiniUpload粗现呢？

**测试阶段**

首先按照此图创建目录和文件

src/MyUpload.php

```
<?php
//下面的MiniUpload与autoload_psr4.php中一致
namespace MiniUpload;

class MyUpload {
    public function test(){
        echo "欢迎你 miniupload!!";
    }
}

```

test.php

```
<?php
require 'vendor/autoload.php';

use MiniUpload\MyUpload as MyUpload;

$miniUpload = new MyUpload();
$miniUpload->test();

```

测试下

ok,成功了！！

**发布阶段**

    到现在我们的包基本上可以在composer下运行了，我可以手动将我的MyUpload.php完善，你也可以将你的MyUpload.php完善。然后就可以准备发布了。

    在准备发布之前，我们还需要办件事，之前我们在执行composer init的时候，有一项是版本信息，我们设定了是dev，如果你已经确保你的代码已经测试都通过了，那么更改下composer.json，将dev改为stable，保存退出，执行composer update命令。

    好，把代码push到github上，有始有终。

```
注意：还没完事，还需要把项目发布到composer包仓库的官方网站<a href="https://packagist.org/" target="_blank">https://packagist.org/</a>

首先，注册个账号，然后菜单栏有个Submit。在下面的Repository URL (Git/Svn/Hg)输入框中输入github链接地址（注意后面带有.git）,再填写一些简短信息后即可完成发布。

接下来就可以通过composer来安装刚刚发布的包了。比如我的

```

```
composer require xuwenzhi/miniupload dev-master

```

*至于为什么后面有个dev-master，是因为我们的包现在还没有release，也就是还没有达到可发布要求。当在github对我们的项目进行release之后，即可去掉dev-master*

但，还没完事，当有人在github上给你提了个bug，然后你迅速的修复了bug并且push到了github，而此时packagist.org并不知道你的这个项目进行了修改，当此时使用composer安装的话，安装的还是之前存在bug的那个版本，So，需要解决这个问题呀~

解决方案：

1.手动方法：到你的packagist（比如我的是[xuwenzhi/miniupload](https://packagist.org/packages/xuwenzhi/miniupload)）的包主页，点击下update，就能从github同步过来。

2.自动方法：也即是当你提交代码到github的时候，自动会更新到packagist.org，这需要在github上增加webhooks。

构建自己的composer包
