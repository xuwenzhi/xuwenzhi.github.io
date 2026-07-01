---
layout: post
title: "让Nginx支持thinkPHP"
tags: nginx php thinkphp
---

**先吐吐槽**

最近换了工作，新公司使用了thinkPHP这个框架，且不说thinkPHP这个框架怎么样吧，也不说我对thinkPHP的个人意见，既然要用这玩应儿，那咱也没办法对不？

好了，言归正传。。。

首先，大家都知道，nginx本身并不像Apache一样支持pathinfo，而我们使用thinkPHP的时候，一般都喜欢用pathinfo的URL模式，为什么？

**为什么都喜欢用pathinfo这种路由？**

1.www.xxx.com/goods/list 这种路由模式很漂亮有木有？如果你不觉得，那容我自嗨一把。

2.www.xxx.com/goods/list 这种路由模式会更加容易被搜索引擎所接受，也就是搜索引擎在收录网页的时候更喜欢pathinfo。

**我的解决思路**

1.既然Nginx不支持pathinfo，那么可不可以让它支持呢？

答：当然可以，[点击这里 go!!!](/nginx-pathinfo),注意:此种配置有点长，如果不想耽误时间可以选择下面这种

2.配置Nginx的rewrite

首先，什么是rewrite？

看图，看到请求是先到达了服务器，然后才到达程序文件，那么既然如此，我们可以在请求还没到达程序的时候做点文章，让原本并不认识pathinfo的Nginx仍然可以正常工作,具体的rewrite请看下方我的配置。

**我的操作步骤**

1.新建一个子的Nginx配置文件

大家知道，Nginx有个主的配置文件，叫做nginx.conf，此次我的操作是新建了一个子的配置文件，放在了./vhost/目录下，你可以定义为www.xxx.com.conf(其中xxx可以替换成你的域名)。

当然并不一定非要www.xxx.com.conf，如果你没有域名，也可以192.168.33.10.conf

2.打开www.xxx.com.conf文件

vim www.xxx.com.conf，原本的结构是这个样子的，有可能你的会跟我一样，但是没关系

```
server
{
    listen 80;
    server_name www.xxx.com xxx.com;
    index index.php index.html index.htm;
        #这里要对应你的项目目录
    root  /home/wwwroot/default/xxx

    location ~ [^/]\.php(/|$)
    {
        try_files $uri =404;
        fastcgi_pass  unix:/tmp/php-cgi.sock;
                fastcgi_index index.php;
                include fastcgi.conf;
        #include pathinfo.conf;
    }
    location /{
        try_files $uri $uri/ /index.php?$query_string;
    }
    location /nginx_status {
         stub_status on;
        access_log   off;
    }
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
        expires      30d;
    }

    location ~ .*\.(js|css)?${
        expires      12h;
    }
    access_log  /home/wwwlogs/xxx/access.log;
}

```

注意：xxx，需要配置成符合你的情况，还有root 那一项需要设置成你的项目目录

3.将配置文件中location / {…}修改成这样

```
location /{
    if (!-e $request_filename){
        rewrite ^(.*)$ /index.php?s=$1 last;
        break;
    }
    #try_files $uri $uri/ /index.php?$query_string;
}

```

注意：if和(!-e $request_filename)中间一定要有一个空格噢~

4.修改后的www.xxx.com.conf文件为

```
server
{
    listen 80;
    server_name www.xxx.com xxx.com;
    index index.php index.html index.htm;
    root  /home/wwwroot/default/xxx

    location ~ [^/]\.php(/|$)
    {
        try_files $uri =404;
        fastcgi_pass  unix:/tmp/php-cgi.sock;
                fastcgi_index index.php;
                include fastcgi.conf;
        #include pathinfo.conf;
    }
    location /{
        if (!-e $request_filename){
            rewrite ^(.*)$ /index.php?s=$1 last;
            break;
        }
        #try_files $uri $uri/ /index.php?$query_string;
    }
    location /nginx_status {
         stub_status on;
        access_log   off;
    }
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
        expires      30d;
    }

    location ~ .*\.(js|css)?${
        expires      12h;
    }
    access_log  /home/wwwlogs/xxx/access.log;
}

```

OK，重启Nginx试试吧。

让Nginx支持thinkPHP
