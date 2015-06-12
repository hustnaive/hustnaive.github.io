---
layout: page
title: Composer包管理器介绍
categories: php
tags: php
published:false
---

# 参考文档

* [Composer官方网站](http://www.phpcomposer.com/)
* [依赖包仓库](https://packagist.org/)

## Composer的安装

参考[Composer安装文档](http://docs.phpcomposer.com/00-intro.html#Downloading-the-Composer-Executable)

## Composer的使用

参考[Composer使用文档](http://docs.phpcomposer.com/01-basic-usage.html)

## 依赖包仓库

### 仓库地址

### 提交自己的扩展

## Composer与Yii2协同

### 通过Composer安装Yii2应用程序脚手架

>打开shell，在一个可以通过本地服务器访问的路径下面执行指令：

	composer global require "fxp/composer-asset-plugin:~1.0.0"
    composer create-project --prefer-dist yiisoft/yii2-app-basic basic

在执行的过程中，你可能还需要提供一下git的accesstoken。

新建token的方式是：

* 访问：<https://github.com/settings/tokens>。
* 点击`Generate new token`。
* Token description填写"composer"备忘。
* 权限按照默认勾选，注意`repo`必须有。
* 确定后，把生成的hash token复制下来，注意这个token只会显示一次。

然后，回到创建项目的终端，将上面的token复制过去。

等待加载完成，你就在工作路径的basic目录下面成功新建了一个yii的脚手架。更详细的参考[安装Yii](https://github.com/hustnaive/yii2/blob/master/docs/guide-zh-CN/start-installation.md)

有人会想，我不想利用脚手架，想要自己根据自己的需求自定义目录，这个时候怎么办？

### 通过Composer自定义安装Yii2


### 给Yii2安装第三方扩展