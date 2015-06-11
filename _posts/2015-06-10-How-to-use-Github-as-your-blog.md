---
layout: default
title: 如何基于GitHub Pages搭建你的博客
---

# 相关参考

* [阮一峰的GitHub Pages和Jekyll入门](http://www.ruanyifeng.com/blog/2012/08/blogging_with_jekyll.html)
* [GitHub Pages Help -- Using Jekyll with Pages](https://help.github.com/articles/using-jekyll-with-pages/)

# 基本步骤

## 前期准备

如果你希望创建一个用户博客（和项目博客相对），那么，你需要在GitHub上有一个username.github.io的仓库，这个username就是你的GitHub的用户名，请替换成自己的。然后，将用户仓库的master分支clone到本地来。

如果你希望创建一个项目的博客，那么你需要在项目的仓库里面创建一个gh-pages分支，这个分支里面放你博客的数据。用户仓库和项目仓库采用不同分支的具体原因参考[GitHub Pages Help -- Using Jekyll with Pages](https://help.github.com/articles/using-jekyll-with-pages/)

一般来说，因为GitHub Page就是基于Jekyll，如果我们不本地预览（实际上大部分时间确实不需要本地预览）就不需要本地安装Jekyll。只需要我们按照Jekyll的语法完成我们的文档，然后push到GitHub上就可以在Github中查看了。这里关于Jekyll的安装不在本文档的范围内。关于安装Jekyll参考[Jekyll安装](http://jekyllrb.com/docs/quickstart/)。

在GitHub的创建好仓库并将对应分支clone到本地后，我们就可以开始我们的博客的搭建过程了。

>开始后面的步骤之前，请确认已经完成以下：
>
* 已经新建了一个仓库名为hustnaive.github.io（依你自己的username而定）
* 我把仓库clone在本地的hustnaive目录下面
* 我的博客的预览地址为：http://hustnaive.github.io

## 创建 _config.yml 配置文件

>shell>>$ touch _config.yml

`_config.yml`是Jekyll的配置文件，里面可以有很多参数，初期，我们可以保持为空就可以了。以后可以根据自己的需要来更新这个文件。

关于`_config.yml`具体有哪些配置参数以及用法详见Jekyll的文档[Jekyll配置](http://jekyllrb.com/docs/quickstart/)。

## 创建 _layout/ 目录

>shell>>$ mkdir _layout

`_layout`顾名思义，这里是放你的布局文件的。在里面新建一个default.html，内容如下：
	
>/hustnaive/_layout/default.html
>
	<!DOCTYPE html>
	<html>
	<head>
		<meta http-equiv="content-type" content="text/html;charset=utf-8" />
		<title>{{page.title}}</title>
	</head>
	<body>
		{{content}}
	</body>
	</html>

里面的`{{page.title}}`的内容是Jekyll的模板语法，代表文章标题。Jekyll使用[Liquid模板语言](https://github.com/shopify/liquid/wiki/liquid-for-designers)，更多可以使用的变量，参考[Jekyll变量参考](http://jekyllrb.com/docs/variables/)。

>现在你的hustnaive目录大致的结构如下：
>
	/hustnaive
	   	|-- _config.yml
	   	|-- _layout/
	    |      	|-- default.html

## 创建 _posts/ 目录，写你的第一篇文章

>shell>>$ mkdir _posts

`_posts`顾名思义，这里放你的博客文章。Jekyll支持Markdown,Textile,以及HTML的文章语法。

`_posts`里面的博客文章的命名格式为`YEAR-MONTH-DAY-title.MARKUP`，比如，新建一篇文章Hello world，那么在`_posts`目录新建文件`2016-6-10-Hello-World.md`，内容如下：

>/hustnaive/_posts/2016-06-10-Hello-World.md
>
	---
	layout: default
	title: hello world
	---
	#Hello World
	>这里是我的第一篇

`---`之间的内容叫**Front Matter**，这里用来设置一些元数据。里面的内容会被Jkeyll引擎解析执行。

这里`layout`代表本页面使用的布局文件，default代表使用前面的default.html作为布局文件。你也可以使用其他的布局文件，只需要按照前面的方式新建你的布局文件放在_layouts里面就可以了。`title`代表文章标题和模板default.html里面的page.title对应

>Front Matter列表
|变量|说明|
|---|----|
|layout|使用的layout,使用_layouts目录中的布局文件（不带扩展名）|
|permalink|默认的日志格式为"/year/month/day/title.html"，如果你不想用这种格式，可以指定你自己的格式|
|published|false or true，是否生成此文章|
|category/categories|除了把文章按照目录进行归类外，你也可以指定这两个属性。归类列表可以是空格分隔的分类名，也可以是一个[YAML列表](http://en.wikipedia.org/wiki/YAML#Lists)。|
|tags|文章的标签，同category一样，可以是空格分隔的标签名或者YAML列表|

**其他**：非以上的部分都是用户自定义的的变量，你可以在当前post里面展示。比如前面的title，你可以在布局里面\{\{page.title}}的形式引用。

**date**：这个属于"out of box"变量，它指示当前文章的编辑时间。

>到了这里，你的目录大致的结构应该变成这样了：
>
	/hustnaive
	   	|-- _config.yml
	   	|-- _layout/
	    |      	|-- default.html
		|-- _posts/
		|		|-- 2016-06-10-Hello-World.md

## 创建 index.html

>shell>>$ touch index.html

index.html是我们的博客的首页，内容如下：

>/hustnaive/index.html
>
	---
	layout: default
	title: The World Is Flat 
	---
	<ul>
		{% for post in site.posts %}
			<li>{{post.date}} 
			<a href="{{post.url}}">{{post.title}}</a></li>
		{% endfor %}
	</ul>
>到了这里，你的目录大致的结构应该变成这样了：
>
	/hustnaive
	   	|-- _config.yml
	   	|-- _layout/
	    |      	|-- default.html
		|-- _posts/
		|		|-- 2016-06-10-Hello-World.md
		|-- index.html

截止到这里，我们的博客的雏形已经搭好了。接下来，我们可以把代码push到github中了。

## push到GitHub

>shell>>$ pwd 
>/path/to/hustnaive 
>shell>>$ git add * 
>shell>>$ git commit -m 'init blog'
>shell>>$ git push origin master

# 美化模板
