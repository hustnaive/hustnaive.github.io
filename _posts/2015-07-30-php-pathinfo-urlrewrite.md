---
layout: page
title: PHP pathinfo 和 url重写
categories: php
tags: php
---

>假设我们的web服务器部署在192.168.59.103:8080，服务器操作系统为ubuntu14.04，php版本为php5.5.9，web服务器为apache，以`apache2ctl -D 'FOREGROUND'`模式运行。

我们的目录结构如下：

    php-mvc/
        |- index.php
            |- test/
                |- index.php

其中/index.php和test/index.php里面的代码一样，都为：

    <?php

    print_r($_SERVER);

即，输出`$_SERVER`环境变量的内容，这个变量存储与服务器有关的环境配置信息。

这里，我们需要关注php里面的一个叫PATH_INFO的环境变量，那么PATH_INFO是什么呢？回答这个问题之前，我们先看几个例子：

访问index.php
---

`http://192.168.59.103:8080/index.php/a/b/c?d=e&f=g`

    Array
    (
        ...

        [SERVER_SOFTWARE] => Apache/2.4.7 (Ubuntu)
        [SERVER_NAME] => 192.168.59.103
        [SERVER_ADDR] => 172.17.0.22
        [SERVER_PORT] => 8080
        [REMOTE_ADDR] => 192.168.59.3
        [DOCUMENT_ROOT] => /var/www/html
        [REQUEST_SCHEME] => http
        [CONTEXT_PREFIX] => 
        [CONTEXT_DOCUMENT_ROOT] => /var/www/html
        [SERVER_ADMIN] => webmaster@localhost
        [SCRIPT_FILENAME] => /var/www/html/index.php
        [REMOTE_PORT] => 52652
        [GATEWAY_INTERFACE] => CGI/1.1
        [SERVER_PROTOCOL] => HTTP/1.1
        [REQUEST_METHOD] => GET
        [QUERY_STRING] => d=e&f=g
        [REQUEST_URI] => /index.php/a/b/c?d=e&f=g
        [SCRIPT_NAME] => /index.php
        [PATH_INFO] => /a/b/c
        [PATH_TRANSLATED] => /var/www/html/a/b/c
        [PHP_SELF] => /index.php/a/b/c
        [REQUEST_TIME_FLOAT] => 1436888490.582
        [REQUEST_TIME] => 1436888490
    )


访问/test/index.php
---

`http://192.168.59.103:8080/test/index.php/a/b/c?d=e&f=g`

    Array
    (
        ...

        [SERVER_SOFTWARE] => Apache/2.4.7 (Ubuntu)
        [SERVER_NAME] => 192.168.59.103
        [SERVER_ADDR] => 172.17.0.22
        [SERVER_PORT] => 8080
        [REMOTE_ADDR] => 192.168.59.3
        [DOCUMENT_ROOT] => /var/www/html
        [REQUEST_SCHEME] => http
        [CONTEXT_PREFIX] => 
        [CONTEXT_DOCUMENT_ROOT] => /var/www/html
        [SERVER_ADMIN] => webmaster@localhost
        [SCRIPT_FILENAME] => /var/www/html/test/index.php
        [REMOTE_PORT] => 52651
        [GATEWAY_INTERFACE] => CGI/1.1
        [SERVER_PROTOCOL] => HTTP/1.1
        [REQUEST_METHOD] => GET
        [QUERY_STRING] => d=e&f=g
        [REQUEST_URI] => /test/index.php/a/b/c?d=e&f=g
        [SCRIPT_NAME] => /test/index.php
        [PATH_INFO] => /a/b/c
        [PATH_TRANSLATED] => /var/www/html/a/b/c
        [PHP_SELF] => /test/index.php/a/b/c
        [REQUEST_TIME_FLOAT] => 1436888285.586
        [REQUEST_TIME] => 1436888285
    )


访问/（apache默认设置index为index.php）
---

`http://192.168.59.103:8080/`

    Array
    (
        ...

        [SERVER_SOFTWARE] => Apache/2.4.7 (Ubuntu)
        [SERVER_NAME] => 192.168.59.103
        [SERVER_ADDR] => 172.17.0.22
        [SERVER_PORT] => 8080
        [REMOTE_ADDR] => 192.168.59.3
        [DOCUMENT_ROOT] => /var/www/html
        [REQUEST_SCHEME] => http
        [CONTEXT_PREFIX] => 
        [CONTEXT_DOCUMENT_ROOT] => /var/www/html
        [SERVER_ADMIN] => webmaster@localhost
        [SCRIPT_FILENAME] => /var/www/html/index.php
        [REMOTE_PORT] => 52499
        [GATEWAY_INTERFACE] => CGI/1.1
        [SERVER_PROTOCOL] => HTTP/1.1
        [REQUEST_METHOD] => GET
        [QUERY_STRING] => 
        [REQUEST_URI] => /
        [SCRIPT_NAME] => /index.php
        [PHP_SELF] => /index.php
        [REQUEST_TIME_FLOAT] => 1436887771.889
        [REQUEST_TIME] => 1436887771
    )


通过上面的示例，你应该知道pathinfo就是我们的请求脚本（xxx.php）在php文件后面的`路径`部分。pathinfo是cgi的标准环境变量，它用于服务器往cgi程序中传递路径信息。而我们知道，php一般是以CGI/FastCGI模式与WEB服务器协作的，所以$_SERVER['PATH_INFO']里面存储着服务器遵循CGI标准传递过来的pathinfo信息。

有人可能会问，我这样大段落的讲pathinfo起什么作用呢？其实，目前大多数的成熟的PHP-MVC框架都是通过pathinfo与url重写来实现其URL路由的。我们经常可以看到浏览器输入的某个地址，但是这个地址缺并没有在我们的webroot目录下面，这都是pathinfo和url重写的功劳。

讲完了pathinfo，下面讲讲url重写是什么了。

URL重写
---

url重写是现代web服务器提供的一种特性，目前主流的nginx、apache、iis都支持url重写。 url重写可以将一个http访问请求内部重定向到另外一个位置。

简单说，我们可以建立一个`path/to/a -> path/to/b`的url重写规则，当我们浏览器访问`path/to/a`的时候，服务器会内部重定向到`path/to/b`，并返回b内容。

这个重写的具体语法不同的服务器有其具体的语法规定，大家可以参考相应的文档，这里不延伸。

那么，结合url重写和pathinfo，我们建立一个`path/to/a -> index.php/path/to/a`的url重写规则，这样，我们就可以在index.php中通过PATH_INFO获取到我们的请求url了，而这条规则则是目前大多数的PHP-MVC框架的核心支撑了。

框架会首先要求服务器配置支持url重写，并将请求重定向到框架的入口文件，然后，入口文件的主要职责就是解析pathinfo，并根据框架的约定来找到对应的代码文件，并执行相应的控制器代码。这样做的主要好处是可以隐藏我们请求URL中的index.php，达到URL美化的目的。


延伸阅读
----

* [PHP在各种WEB服务器的运行模式详解](http://www.jb51.net/article/37759.htm)
* [CGI/FastCGI详解](http://www.cnblogs.com/skynet/p/4173450.html)
* [Nginx下支持PATH_INFO详解](http://www.nginx.cn/426.html)
* [Nginx安装与使用](http://www.cnblogs.com/skynet/p/4146083.html)

