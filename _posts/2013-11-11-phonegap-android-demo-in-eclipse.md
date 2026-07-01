---
layout: post
title: "使用PhoneGap在eclipse中运行Android小demo"
tags: phonegap android
---

再看下面的内容之前，请先使用eclipse搭建好Android开发环境。

	 

	步骤:

	** ①**

	** 

   **

	**SDK尽量选择较低版本的，比如android不识别Phonegap**

	②

	** 在assets新建www文件夹**

	**③**

	**右侧为PhoneGap安卓包，按照红线将文件copy到指定的文件夹中**

	**④**

	**这是导入之后的效果图**

	⑤

	**打开它**

	⑥

	**会看到这个**

	⑦

	**将文件修改成这个样子，如果你看到了出错，或者是警告，不要紧张，可能经过一会儿的操作，就会将错误或者警告消除了**

	⑧

	**鼠标右击选择Build Path ,再选择Configure Build Path**

	**⑨**

	**点击Add Jar**

	①0

	**选择libs中的phonegap-2.9.0.jar包，之后点击OK，之后再OK**

	**①①**

	**    在www文件夹下建立一个html文件，就本例子而言一定要保存成index.html，因为刚才设定在index.html文件启动**

	①②

	**在新建的index.html文件中添加如下代码，进行测试，激动人心的时刻来了!**

	①③

	**右键FirstGap->Run As ->Android Application ,然后选择设备，进行观看**

	①④

	**这就是会看到的结果了。**

	** **

	** **

	**①⑤    **

	**如果你看到了这个HelloWorld，但是却出现了一个对话框强制关闭（Forceclose）了你的程序**

	**不要担心，这是因为Google为了保证操作系统的安全，而强制关闭了你的程序，原因在于PhoneGap并不是google的产品，对于一些侵犯安全的问题，google会强制关闭。**

	**解决办法:找到AndroidManifest.xml文件**

	**后面添加**

	**<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"> </uses-permission>**

	**再运行试试看吧。**

使用PhoneGap在eclipse中运行Android小demo
