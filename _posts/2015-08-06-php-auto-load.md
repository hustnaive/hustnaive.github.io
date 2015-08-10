---
layout: page
title: PHP自动加载介绍（autoload）
categories: php
tags: php
---

PHP类加载的机制
---

传统的PHP使用一个类时，首先需要将类所在的代码文件加载进来，那么如何加载呢？php提供两组函数：`include`和`require`。`include`用法如下：

	<?php
    include 'path/to/clsa.php';
    $a = new clsa(); //假设clsa.php提供一个clsa类。

include函数会把`path/to/clsa.php`的代码加载进来，并在当前位置以html模式开启一个新的执行上下文，执行加载进来的类和文件。

注意的是，这里如果你在include进来的代码文件里面定义了一些变量，那么这些变量仅限于执行上下文，但是引入这个文件的父代码文件中的变量可以带入到新的上下文中（即在include进来的php代码文件可以引用父代码文件中的变量）。

同时，include的默认行为是把文件为一个html文档处理，即输出内容。如果你里面包含php代码，你需要用`<?php`标签将语句包含起来。

`require`和`include`的基本相同，唯一的区别在于如果类文件不存在或者有执行出错，那么include只报一个warning，但是require则会产生一个致命错误并中断处理流程。

同时，在使用require时，如果是在流程控制中，无论是否走到该分支，require都会执行。也就是说：

	<?php
	if(true) {
		require 'a.php';
	}
	else require 'b.php';

这里，a.php和b.php都会被加载进来。

>简单说：
>
> * **require** 的英文意思是 '需要，有赖于'。如果使用了这条语句，也就是告诉PHP内核，我这个程序需要这个文件，有赖于这个文件。或者通俗点儿讲就是：我要她！所以，PHP如果发现require参数中的文件不存在的话，就会报fatal error，并且停止执行下面的语句。
> * **include** 的英文意思是 '包括，包含'。如果使用了这条语句，也就是告诉PHP内核，程序执行时，把这个文件包含进来。通俗点儿讲就是：带上她！所以，PHP如果找不到的话，仅仅会提示说，找不到她，无法带上她。而不会停止下面脚本的执行，因为我们并没有告诉PHP内核，下面的程序有赖于这个子文件。
> 参考：<http://blog.sina.com.cn/s/blog_5d2673da0100cp6o.html>

通过`require/include`函数，我们可以在任意位置执行任意类和方法，只要我们把类或者方法所在的代码文件加载到当前执行上下文。

这里`require/include`还有一对姊妹函数`require_once/include_once`，用法类似。但是*_once函数的不同之处是会记住一个已经加载进来的代码文件，如果当前执行上下文已经加载过某代码文件，那么就不会再次加载。这样的好处是避免重复加载造成的命名冲突。

同时，`require/include`还可以有返回值，如果在include进来的代码文件中的非{}片段中有return语句的话，那么这个return语句会作为`require/include`的返回值。

也就是说，我们可以如下做：
	
	// cfg.php
	<?php
	$cfg = [1,2,3];
	return $cfg;
	
在另外一个地方，我们可以如下include这个文件
	
	<?php
		$cfg = require('cfg.php');
		print_r($cfg);

这块更深入的这里不做详细介绍，请自行百度或者谷歌之。

* [require/include用法详解](http://www.cnblogs.com/xia520pi/p/3697099.html)


现在问题来了，什么叫Autoload？
---

在某个php执行上下文中，在new某个类，或者静态调用时如果某个类没有找到，php默认会首先触发`__autoload`回调，由回调尝试去加载类代码文件。这个回调由用户自己实现，通过用户规定的类名到代码文件的映射规则得到代码文件路径，并使用`require/include`函数去加载代码文件。


比如：

	<?php
	__autoload($clsname) {
		require $clsname.'.php';
	}

	$a = new A();

但是，`__autoload`有一个不好的地方是只允许注册一个回调。同时，因为我们在使用一些第三方类库的时候，经常需要维护各自的autoload调用规则。所以，这里在php5.1.2之后，我们大多使用`spl_autoload_register`来替代`__autoload`。

`spl_autoload_register`的用法很简单：

	spl_autoload_register(function($clsname){
		$clspath = explode('\\',$clsname);
		if($clspath[0] === 'web') {
			$clspath[0] = 'src';
		}
		require dirname(__DIR__).DIRECTORY_SEPARATOR.implode(DIRECTORY_SEPARATOR,$clspath).'.php';
	});
	
它的参数其实就是一个`__autoload`回调，你可以多次调用`spl_autoload_register`来往队列注册多个回调。

这样，使用autoload函数的好处是，如果我一个代码文件中需要使用100个类，我不需要一个个的将其require进来，我只需要将其按照一定的规范组织代码文件。然后注册一个autoload函数，按照我们的规范来自动的根据类名来找到对应的类文件，并require到当前执行环境。

关于PHP的Autoload，我们不得不提的是PSR0-PSR4规范。这两个规范不是PHP的语言标准的一部分，只是PHP使用自动加载的代码组织过程中的一个标准规范，当然你可以完全不遵循这个规范，但是建议你最好能够遵循。

一个简单的AutoLoader实例
---

	/**
	 * 自动加载器，遵循psr-4规范
	 * @author fangl
	 *
	 */
	class Autoloader {
	
	    static $_namespaces = [
	        'web' => 'src',
	    ];
	
	    /**
	     * 增加命名空间到路径的映射（以帮助自动加载器能够找到对应的路径）
	     * 注意对应的代码里面的命名空间要和声明一致，否则即使文件正确引入，也会报找不到类文件错误
	     * @param string $namespace 命名空间（只接受一个字符串）
	     * @param string $path 命名空间对应的路径
	     */
	    static function addNameSpace($namespace,$path) {
	        self::$_namespaces[trim($namespace,'\\/')] = trim($path,'\\/');
	    }
	
	    /**
	     * 获取命名空间的加载路径，如果命名空间不存在，返回原值
	     * @param string $namespace
	     * @return Ambigous <unknown, multitype:string , string>
	     */
	    static function getPath($namespace) {
	        return isset(self::$_namespaces[$namespace])?self::$_namespaces[$namespace]:$namespace;
	    }
	
	    /**
	     * 自动加载回调函数
	     * @param string $clsname
	     */
	    static function autoload($clsname) {
	        $clsname = trim($clsname,'\\/');
	        $clspath = explode('\\',$clsname);
	        $clspath[0] = self::getPath($clspath[0]);
	        require APP_ROOT.DIRECTORY_SEPARATOR.implode(DIRECTORY_SEPARATOR,$clspath).'.php';
	    }
	}

PSR0-PSR4规范扩展阅读：

- <http://blog.csdn.net/sky_zhe/article/details/38615615>
- <http://www.sitepoint.com/battle-autoloaders-psr-0-vs-psr-4/>
