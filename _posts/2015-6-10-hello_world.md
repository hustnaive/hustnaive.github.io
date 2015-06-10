---
layout: default
title: 如何基于GitHub Pages和Jekyll搭建博客
---

# 相关参考

* [阮一峰的GitHub Pages和Jekyll入门](http://www.ruanyifeng.com/blog/2012/08/blogging_with_jekyll.html)
* [GitHub Pages Help -- Using Jekyll with Pages](https://help.github.com/articles/using-jekyll-with-pages/)

# 我的步骤

## 前期准备
如果你希望创建一个用户博客（和项目博客相对），那么，你需要在GitHub上有一个username.github.io的仓库，这个username就是你的GitHub的用户名，请替换成自己的。然后，用Git将用户仓库的master分支clone到本地来。

如果你希望创建一个项目的博客，那么你需要在项目的仓库里面创建一个gh-pages分支，这个分支放你的博客的内容数据。具体原因参考[GitHub Pages Help -- Using Jekyll with Pages](https://help.github.com/articles/using-jekyll-with-pages/)

一般来说，我们不需要本地安装Jekyll，只需要我们按照Jekyll的语法完成我们的文档，然后push到GitHub上就可以了，这里关于Jekyll的安装不在本文档的范围内。

在Github的仓库创建好并clone到本地后，我们就可以开始我们的博客的搭建过程了。以下假设你的仓库在本地的hustnaive目录下面。

## 创建 _config.yml 配置文件

config配置文件里面可以有很多参数，这里我创建的用户博客默认为空。

如果你创建的是项目博客的话，建议这里增加一个baseurl配置，设置为项目路径/prjpath


## 创建 _layout/ 目录

## 创建 _posts/ 目录

## 创建 index.html

## push到GitHub

# 自定义
