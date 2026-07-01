---
layout: post
title: "HTML5离线应用构建"
tags: html5 web
---

这是一段简单的MANIFEST文件代码，除了第一行，剩下的部分是需要离线的文件(html/css/js及图片)

```
CACHE MANIFEST
index.html
stylesheet.css
images/logo.png
scripts/main.js

```

下面是一段比较复杂的manifest文件

```
CACHE MANIFEST
# 指定一个版本号
# version 1
# 该类别指定要缓存的资源文件
CACHE:
/favicon.ico
index.html
stylesheet.css
images/logo.png
scripts/main.js

# 指定不进行缓存的资源文件
NETWORK:
login.php
http://foocoder.com

# 每行指定两个文件，第一个为在线时使用的资源，第二个是离线时使用的资源
FALLBACK:
/main.py /static.html        #/main.py  为在线时使用的资源   static.html为离线时使用的资源
images/large/ images/offline.jpg
*.html /offline.html

```

①以#开头为注释

②CACHE类别指定需要缓存的文件

③NETWORK类别指定不缓存的资源文件，即只在联网的情况下才能访问。

④FALLBACK每一行都会指定两个文件，第一个为在线时使用的资源，第二个为离线时使用的备用资源。其中*为通配符，表示在线时使用所有的.html文件。

如何使用这个缓存文件

```
<html manifest="app.manifest">
...
</html>

```

注意:

①指定MINE类型

manifest文件的MINE类型必须要指定为text/cache-manifest，所以需要在服务器做相应配置对该类型添加支持。

        例如:apache服务器，需要在配置mime.types中添加如下内容：       AddType text/cache-manifest .manifest

缓存的工作过程

①首次访问

在首次访问时，没有什么特别，浏览器解析index.html，请求所有的资源文件。随后就会处理manifest文件，请求所有的manifest中的资源文件，注意，即使之前已经请求过了所有的资源文件，这里必须进行重复请求。最后将这些文件缓存到本地。

②.再次访问

再次访问时，浏览器发现有本地缓存，所以会加载本地缓存内容。随后会向服务端请求manifest文件，如果manifest文件未更新，返回304代码，浏览器不做处理。如果manifest已经更新过，则请求所有manifest中的资源文件，重新对其缓存。

问题:也就是会有一个问题，如果我的浏览器已经记住我已经在本地进行了缓存，即使服务器上更新了数据，我的浏览器在再次打开的时候也无法去主动的获取新数据，那么该怎么解决呢？

使用applicationCache对象来达到目的

```
var appCache = window.applicationCache;  //通过window.applicationCache来获取到当前的缓存状态

switch (appCache.status) {

  case appCache.UNCACHED: // UNCACHED == 0

    return 'UNCACHED';

    break;

  case appCache.IDLE: // IDLE == 1

    return 'IDLE';

    break;

  case appCache.CHECKING: // CHECKING == 2

    return 'CHECKING';

    break;

  case appCache.DOWNLOADING: // DOWNLOADING == 3

    return 'DOWNLOADING';

    break;

  case appCache.UPDATEREADY:  // UPDATEREADY == 4

    return 'UPDATEREADY';

    break;

  case appCache.OBSOLETE: // OBSOLETE == 5

    return 'OBSOLETE';

    break;

  default:

    return 'UKNOWN CACHE STATUS';

    break;

};

```

既然可以获得状态，我们只需要请求更新，随后在状态为appCache.UPDATEREADY时更新缓存时即可。

```
var appCache = window.applicationCache;

appCache.update(); // 开始更新   还没更新

if (appCache.status == window.applicationCache.UPDATEREADY) {

  appCache.swapCache();  // 更新缓存 这时进行缓存 在缓存对象为UPDATEREADY时

}

applicationCache.update();//方法会尝试更新用户缓存，而applicationCache.swapCache()方法会对本地缓存进行更新

```

注意:上面只是在检查你的本地缓存是否与服务器上同步，接下来还要对服务器的数据更新进行加载

即使更新了缓存，还是需要重新加载才能使用最新的资源，此时可以提示用户更新。只需要监听onUpdateReady事件，该事件在缓存被下载到本地后出发，从而可以在此时提示用户：

```
window.addEventListener('load', function(e) {

  window.applicationCache.addEventListener('updateready', function(e) {

    if (window.applicationCache.status == window.applicationCache.UPDATEREADY) {

     //更新本地缓存

      window.applicationCache.swapCache();

      if (confirm('已经有新的版本，是否立刻切换到最新版?')) {

        window.location.reload();

      }

    } else {

    }

  }, false);

}, false);

```

到此为止，也就可以实现了动态缓存的目的。

applicationCache对象还提供了其他事件

onchecking，onerror，onnoupdate，ondownloading，onprogress，onupdateready，oncached和onobsolete

例子:在整个浏览器与服务端交互的过程中，所有的错误都会出发error事件，我们可以通过监听error事件进行处理：

```
var appCache = window.applicationCache;

appCache.addEventListener('error', handleCacheError, false)

function handleCacheError(e) {

  alert('Error: Cache failed to update!');

};

```

**注意事项**

站点离线存储的容量限制是5M

如果manifest文件，或者内部列举的某一个文件不能正常下载，整个更新过程将视为失败，浏览器继续全部使用老的缓存

引用manifest的html必须与manifest文件同源，在同一个域下

在manifest中使用的相对路径，相对参照物为manifest文件

CACHE MANIFEST字符串应在第一行，且必不可少

系统会自动缓存引用清单文件的 HTML 文件

manifest文件中CACHE则与NETWORK，FALLBACK的位置顺序没有关系，如果是隐式声明需要在最前面

FALLBACK中的资源必须和manifest文件同源

当一个资源被缓存后，该浏览器直接请求这个绝对路径也会访问缓存中的资源。

站点中的其他页面即使没有设置manifest属性，请求的资源如果在缓存中也从缓存中访问

当manifest文件发生改变时，资源请求本身也会触发更新

参考网址:[http://www.html5rocks.com/zh/tutorials/appcache/beginner/](http://www.html5rocks.com/zh/tutorials/appcache/beginner/)

HTML5离线应用构建
