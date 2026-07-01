---
layout: post
title: "phonegap获取本地内网IP地址(IPV4)"
tags: phonegap network
---

做程序就是这样，永远不太知道在行走的过程之中会遇到什么问题，所以，在这两天的开发过程中需要通过phonegap获取到手机内网的IPV4地址，当然第一次想到的是使用phonegap插件，百度上找资料一无所获，只好Google了，国外讨论这个问题的帖子也很少，但是无意之中发现了一篇博客，但需要翻墙，很不错，链接地址 : [http://simonmacdonald.blogspot.in/2012/08/so-you-wanna-write-phonegap-200-android.html](http://simonmacdonald.blogspot.in/2012/08/so-you-wanna-write-phonegap-200-android.html)

不过我在这里将该网址里面的代码复制了下来仅供参考

```
cordova.define("cordova/plugin/ipaddress",
function(require, exports, module) {
var exec = require("cordova/exec");
var IPAddress = function () {};

var IPAddressError = function(code, message) {
this.code = code || null;
this.message = message || '';
};

IPAddressError.NO_IP_ADDRESS = 0;

IPAddress.prototype.get = function(success,fail) {
exec(success,fail,"ipAddress",
"get",[]);
};

var ipAddress = new IPAddress();
module.exports = ipAddress;
});

```

 

**IpAddress.java**

package com.example.qrcode;//需要重新配置

import java.net.InetAddress;

import java.net.NetworkInterface;

import java.net.SocketException;

import java.util.Enumeration;

import android.app.Activity;

import android.content.Context;

import android.net.wifi.WifiInfo;

import android.net.wifi.WifiManager;

import android.os.Bundle;

import android.util.Log;

import android.widget.TextView;

import org.apache.cordova.api.Plugin;

import org.apache.cordova.api.PluginResult;

import org.json.JSONArray;

import android.util.Log;

public class IpAddress extends Plugin {

public PluginResult execute(String action, JSONArray args, String callbackId) {

if (action.equals(“get”)) {

String ipAddress = getIpAddress();

if (ipAddress != null && ipAddress.length() > 0) {

return new PluginResult(PluginResult.Status.OK, ipAddress);

} else {

return new PluginResult(PluginResult.Status.ERROR);

}

} else {

return new PluginResult(PluginResult.Status.INVALID_ACTION);

}

}

private String getIpAddress() {

try {

for (Enumeration en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements();) {

NetworkInterface intf = en.nextElement();

for (Enumeration enumIpAddr = intf.getInetAddresses(); enumIpAddr.hasMoreElements();) {

InetAddress inetAddress = enumIpAddr.nextElement();

if (!inetAddress.isLoopbackAddress() && !inetAddress.isLinkLocalAddress()) {

return inetAddress.getHostAddress().toString();

}

}

}

} catch (SocketException ex) {

Log.e(“WifiPreference IpAddress”, ex.toString());

}

return null;

}

}

直接从上述网址复制下来的东西有点问题，以至于我后来获取到的IP地址是IPV6的地址，上面的这个IpAddress.java是我修改后的，完全没问题。

**下面我们来具体使用这个IpAddress插件**

**①新建一个项目，项目名称可以叫做Ipaddress**

并且将PhoneGap库加入进去，这里我就不做详细介绍了，可以参考我的另外一篇文章[http://blog.csdn.net/u014646984/article/details/24936779](http://blog.csdn.net/u014646984/article/details/24936779)

**②将上面的IpAddress.java移动至指定文件夹下**

移动进去后并打开

将报错的第一行，修改为

package com.example.ipaddress;

**③打开res/xml/config.xml文件**

在<plugins></plugins>中间加入如下代码

<plugin name=“ipAddress” value=“com.example.ipaddress.IpAddress”/>

其中value值根据你的项目名称而进行相应修改。

**④打开Manifest.xml加入权限**

<uses-permission android:name=“android.permission.INTERNET” />

<uses-permission android:name=“android.permission.ACCESS_WIFI_STATE” />

<uses-permission android:name=“android.permission.CHANGE_WIFI_STATE”/>

 

**⑤在assets/www中新建index.html，并将phonegap-x.x.x.js 和 IpAddress.js移动到www文件夹中**

**⑥修改index.html**

<!DOCTYPE html>

<html>

<head>

<script src=”phonegap-2.9.0.js” type=”text/javascript”></script>

<script src=”IpAddress.js” type=”text/javascript”></script>

<script>

function init(){

console.log(“GOT AN ONLOAD!!!”)

document.addEventListener(“deviceready”, deviceReady, true);

}

function deviceReady() {

console.log(“Device ready”);

var ipAddress = cordova.require(“cordova/plugin/ipaddress”);

ipAddress.get(function(address) {

alert(address);

console.log(“IP Address = ” + address);

}, function() {

console.log(“error”);

});

}

</script>

</head>

<body onload=”init();”>

</body>

</html>

**接下来就可以运行程序，观察结果了**

以上就是这个简短的教程，但中间还出现了点小插曲，由于我是直接在国外的那个链接中将代码复制下来的，在程序运行成功后，获取的IP地址是IPV6的

所以我就直接对IpAddress.java修改了，多亏了这位仁兄  [http://blog.csdn.net/stormwy/article/details/8832164](http://blog.csdn.net/stormwy/article/details/8832164)，上面我贴出的IpAddress.java就是我修改后的结果了，直接复制下来就好。

phonegap获取本地内网IP地址(IPV4)
