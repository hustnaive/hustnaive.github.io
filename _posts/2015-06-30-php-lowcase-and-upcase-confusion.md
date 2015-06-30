---
layout: page
title: PHP大小写问题整理
categories: php
tags: php
---
PHP对大小写敏感问题的处理比较乱，写代码时可能偶尔出问题，所以这里总结一下。
但我不是鼓励大家去用这些规则。推荐大家始终坚持“大小写敏感”，遵循统一的代码规范。

1. 变量名区分大小写
---

代码如下:

	 <?php
	 $abc = 'abcd';
	 echo $abc; //输出 'abcd'
	 echo $aBc; //无输出
	 echo $ABC; //无输出

2. 常量名默认区分大小写，通常都写为大写
---
（但没找到能改变这个默认的配置项，求解）

代码如下:

	 <?php
	 define("ABC","Hello World");
	 echo ABC; //输出 Hello World
	 echo abc; //输出 abc

3. php.ini配置项指令区分大小写
---

如 file_uploads = 1 不能写成 File_uploads = 1

4. 函数名、方法名、类名不区分大小写
---

但推荐使用与定义时相同的名字

代码如下:

	 <?php
	 function show(){
	 echo "Hello World";
	 }
	 show(); //输出 Hello World 推荐写法
	 SHOW(); //输出 Hello World

代码如下:

	 <?php
	 class cls{
	 static function func(){
	 echo "hello world";
	 }
	 }
	 Cls::FunC(); //输出hello world

5. 魔术常量不区分大小写，推荐大写
---

包括：__LINE__、__FILE__、__DIR__、__FUNCTION__、__CLASS__、__METHOD__、__NAMESPACE__。

代码如下:

	 <?php
	 echo __line__; //输出 2
	 echo __LINE__; //输出 3

6. NULL、TRUE、FALSE不区分大小写
---

代码如下:

	 <?php
	 $a = null;
	 $b = NULL;
	 $c = true;
	 $d = TRUE;
	 $e = false;
	 $f = FALSE;
	 var_dump($a == $b); //输出 boolean true
	 var_dump($c == $d); //输出 boolean true
	 var_dump($e == $f); //输出 boolean true 

>PHP变量名区分大小写，函数名不区分大小写，经常被新手忽视的小细节：

	<?php 
	    $aaa = "jb51.net"; 
	    $AAA = "JB51.CN"; 
	    echo $aaa.'-'.$AAA;  //jb51.net-JB51.CN 
	?> 

PHP函数名不区分大小写测试：

	<?php 
	    function bbb(){ 
	        echo 'abc'; 
	    } 
	    function BBB(){ 
	        echo "Abc"; 
	    } 
	?> 
上面这段代码会报错：( ! ) Fatal error: Cannot redeclare BBB()


---
来源：<http://www.jb51.net/article/38579.htm>