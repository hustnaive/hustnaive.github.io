---
layout: page
title: 基于GIT的敏捷开发发布流程
categories: php
tags: php
---

我们来看一段代码：

	<?php
	
	class A {
	    const CLS = 'A';
	    static function test() {
	        echo self::CLS.PHP_EOL;
	        echo __CLASS__.PHP_EOL;
	    }
	    
	    public function run() {
	        self::test();
	    }
	}
	
	class B extends A {
	    const CLS = 'B';
	    static function test() {
	        echo self::CLS.PHP_EOL;
	        echo __CLASS__.PHP_EOL;
	    }
	}
	
	$a = new A;
	$a->run();
	
	$b = new B;
	$b->run();

这段代码输出：

	A
	A
	A
	A

PHP允许子类重写父类的静态成员方法，同时，5.2以下版本的PHP中，通过`self`关键字来引用静态的成员方法；但是，针对重写的场景，`self`关键字有一个bug，如上示例，子类中`self::test`也是调用的父类的`test`方法，而非子类重写的方法。所以，针对这种场景，5.3版本增加了一个`static::`关键字来引用重写后的方法或成员。

修改上述示例如下：

	<?php
	
	class A {
	    const CLS = 'A';
	    static function test() {
	        echo self::CLS.PHP_EOL;
	        echo __CLASS__.PHP_EOL;
	    }
	    
	    public function run() {
	        static::test();
	    }
	}
	
	class B extends A {
	    const CLS = 'B';
	    static function test() {
	        echo self::CLS.PHP_EOL;
	        echo __CLASS__.PHP_EOL;
	    }
	}
	
	$a = new A;
	$a->run();
	
	$b = new B;
	$b->run();

修改后，输出：

	A
	A
	B
	B

看到没有，得到我们期望的输出了。所以，这里，对于5.3以上的PHP版本，建议使用`static`关键字来引用静态成员方法了，除非你确定是需要调用父类的，不然会导致重载无效。

其实针对这种场景挺扯淡的，对static方法的重写我不理解目的何在？


网上搜了一下，看到别人的一个示例，演示`self`和`static`的区别：


> self refers to the same class whose method the new operation takes place in.
static in PHP 5.3's late static bindings refers to whatever class in the hierarchy which you call the method on.
In the following example, B inherits both methods from A. self is bound to A because it's defined in A's implementation of the first method, whereas static is bound to the called class (also see  get_called_class() ).

	<?php
	class A {
	  public static function get_self() {
	    return new self();
	  }
	 
	  public static function get_static() {
	    return new static();
	  }
	}
	 
	class B extends A {}
	 
	echo get_class(B::get_self()); // A
	echo get_class(B::get_static()); // B
	echo get_class(A::get_static()); // A


针对它的这种场景，还是真得用`static`关键字代替`self`，不然单例模式可能就不是按照期望的方式运行了。