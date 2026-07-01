---
layout: post
title: "Nginx 配置 Pathinfo"
tags: nginx php
---

```
今天想弄弄PHP的伪静态，想通过Pathinfo的方式来从新配置下URL，由于我用的是Nginx服务器，默认不提供Pathinfo，所以只能配置下。

```

我的Nginx的配置文件在  /etc/nginx/目录，Nginx有一个主配置文件nginx.conf，然后在/etc/nginx/conf.d/目录中有一些子的配置文件，这次配置我主要在这个主配置文件中配置。

⒈使用vim打开nginx.conf，在没有配置Pathinfo之前的nginx.conf是这样的

```
user        nginx      nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log;
#error_log  /var/log/nginx/error.log  notice;
#error_log  /var/log/nginx/error.log  info;

pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] '
                     'fwf[$http_x_forwarded_for] tip[$http_true_client_ip] '
                     '$upstream_addr $upstream_response_time $request_time '
                     '$geoip_country_code '
                     '$http_host $request '
                     '"$status" $body_bytes_sent "$http_referer" '
                     '"$http_accept_language" "$http_user_agent" ';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server{
        listen 80;
        server_name a.com;
        index index.php;
        root /usr/share/nginx/html;

        location / {
            if (!-e $request_filename) {
                    rewrite  ^/(.*)$  /index.php/$1  last;
                    break;
            }
        }
    }

    # Load config files from the /etc/nginx/conf.d directory
    # The default server is in conf.d/default.conf
    include /etc/nginx/conf.d/*.conf;

}

```

⒉在server块中添加一段配置，配置完后 server块的内容是这样的

```
server{
    listen 80;
    server_name a.com;
    index index.php;
    root /usr/share/nginx/html;
        location / {
        if (!-e $request_filename) {
                    rewrite  ^/(.*)$  /index.php/$1  last;
                    break;
        }
        }

    location ~ \.php {
         fastcgi_pass 127.0.0.1:9000;
         fastcgi_index index.php;
         include ./conf.d/fcgi.conf;
         set $real_script_name $fastcgi_script_name;
         if ($fastcgi_script_name ~ "^(.+?\.php)(/.+)$") {
             set $real_script_name $1;
             set $path_info $2;
         }
         fastcgi_param SCRIPT_FILENAME $document_root$real_script_name;
         fastcgi_param SCRIPT_NAME $real_script_name;
         fastcgi_param PATH_INFO $path_info;
    }
}

```

⒊再仔细看下，新增的这部分location块中有一行 include ./conf.d/fcgi.conf ，如果系统中没有这个文件，那么需要把它放置到conf.d文件夹内，下载地址我已经为你准备好了 [http://pan.baidu.com/s/1nt8bEWh](http://pan.baidu.com/s/1nt8bEWh)

⒋重启Nginx，执行 service nginx restart，如果有报错的话，说明配置文件有语法错误，可以通过nginx的error.log分析错误，如果重启成功，则往下走。

⒌检查是否配置成功

在网站根目录中新建一个test.php，在其中添加下面的代码。

```
<?php
print_r($_SERVER);
?>

```

在浏览器中访问test.php，并在后面加上/2/1，可以在$_SERVER全局变量中发现PATH_INFO这一项

Nginx 配置 Pathinfo
