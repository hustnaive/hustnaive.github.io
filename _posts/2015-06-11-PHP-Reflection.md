---
layout: page
title: PHP反射机制整理
categories: php
tags: php
---
# 参考文档

* PHP反射API官方文档：<http://php.net/manual/zh/class.reflection.php>

# PHP版本要求

PHP5以上

# 一、反射获取PHP扩展相关信息

## 1.1、核心API：[ReflectionExtension](http://php.net/manual/zh/class.reflectionextension.php)、[ReflectionZendExtension](http://php.net/manual/zh/class.reflectionzendextension.php)

### [ReflectionExtension](http://php.net/manual/zh/class.reflectionextension.php)：报告一个扩展（extension）的有关信息

	ReflectionExtension implements Reflector {
		/* 属性 */
		public $name ;
		/* 方法 */
		final private void __clone ( void )
		public __construct ( string $name )
		public static string export ( string $name [, string $return = false ] )
		public array getClasses ( void )
		public array getClassNames ( void )
		public array getConstants ( void )
		public array getDependencies ( void )
		public array getFunctions ( void )
		public array getINIEntries ( void )
		public string getName ( void )
		public string getVersion ( void )
		public void info ( void )
		public void isPersistent ( void )
		public void isTemporary ( void )
		public string __toString ( void )
	}

### [ReflectionZendExtension](http://php.net/manual/zh/class.reflectionzendextension.php)：报告一个ZendExt的有关信息（PHP >= 5.4.0，和ReflectionExtension异同？）

	ReflectionZendExtension implements Reflector {
		/* 属性 */
		public $name ;
		/* 方法 */
		final private void __clone ( void )
		public __construct ( string $name )
		public static string export ( string $name [, string $return ] )
		public string getAuthor ( void )
		public string getCopyright ( void )
		public string getName ( void )
		public string getURL ( void )
		public string getVersion ( void )
		public string __toString ( void )
	}


## 1.2、用法

	<?php
	// The demonstration for the class "ReflectionExtension".
	
	function REData(ReflectionExtension $re, $return=false) {
	
	    defined('UNDEFINED') || define('UNDEFINED','%undefined%');
	    $_data = [];
	
	    $_data['getName:'] = $re->getName() ?: UNDEFINED;
	    $_data['getVersion:'] = $re->getVersion() ?: UNDEFINED;
	    $_data['info:'] = $re->info() ?: UNDEFINED;
	    $_data['getClassName:'] = PHP_EOL.implode(", ",$re->getClassNames()) ?: UNDEFINED;     
	    foreach ($re->getConstants() as $key => $value) $_data['getConstants:'] .= "\n{$key}:={$value}";
	    $_data['getDependencies:'] = $re->getDependencies() ?: UNDEFINED;
	    $_data['getFunctions:'] = PHP_EOL.implode(", ",array_keys($re->getFunctions())) ?: UNDEFINED;
	    $_data['getINIEntries:'] = $re->getINIEntries() ?: UNDEFINED;
	    $_data['isPersistent:'] = $re->isPersistent() ?: UNDEFINED;
	    $_data['isTemporary:'] = $re->isTemporary() ?: UNDEFINED;
	
	    return print_r($_data, $return);
	}
	
	REData( new ReflectionExtension( 'Reflection' ) );
	REData( new ReflectionExtension( 'zlib' ) );
	
	// Reflection
	// Reflection => enabled
	// Version => $Id: 60f1e547a6dd00239162151e701566debdcee660 $
	/*
	Array
	(
	    [getName:] => Reflection
	    [getVersion:] => $Id: 60f1e547a6dd00239162151e701566debdcee660 $
	    [info:] => %undefined%
	    [getClassName:] =>
	ReflectionException, Reflection, Reflector, ReflectionFunctionAbstract, Reflecti
	onFunction, ReflectionParameter, ReflectionMethod, ReflectionClass, ReflectionOb
	ject, ReflectionProperty, ReflectionExtension, ReflectionZendExtension
	    [getDependencies:] => %undefined%
	    [getFunctions:] =>
	
	    [getINIEntries:] => %undefined%
	    [isPersistent:] => 1
	    [isTemporary:] => %undefined%
	)
	*/
	// zlib
	// ZLib Support => enabled
	// Stream Wrapper => compress.zlib://
	// Stream Filter => zlib.inflate, zlib.deflate
	// Compiled Version => 1.2.7
	// Linked Version => 1.2.7
	// Directive => Local Value => Master Value
	// zlib.output_compression => Off => Off
	// zlib.output_compression_level => -1 => -1
	// zlib.output_handler => no value => no value
	/*
	Array
	(
	    [getName:] => zlib
	    [getVersion:] => 2.0
	    [info:] => %undefined%
	    [getClassName:] =>
	
	    [getConstants:] =>
	FORCE_GZIP:=31
	FORCE_DEFLATE:=15
	ZLIB_ENCODING_RAW:=-15
	ZLIB_ENCODING_GZIP:=31
	ZLIB_ENCODING_DEFLATE:=15
	    [getDependencies:] => %undefined%
	    [getFunctions:] =>
	readgzfile, gzrewind, gzclose, gzeof, gzgetc, gzgets, gzgetss, gzread, gzopen, g
	zpassthru, gzseek, gztell, gzwrite, gzputs, gzfile, gzcompress, gzuncompress, gz
	deflate, gzinflate, gzencode, gzdecode, zlib_encode, zlib_decode, zlib_get_codin
	g_type, ob_gzhandler
	    [getINIEntries:] => Array
	        (
	            [zlib.output_compression] =>
	            [zlib.output_compression_level] => -1
	            [zlib.output_handler] =>
	        )
	
	    [isPersistent:] => 1
	    [isTemporary:] => %undefined%
	)
	*/

# 二、反射获取类、实例、方法相关信息

## 2.1、核心API：[ReflectionClass](http://php.net/manual/zh/class.reflectionclass.php)、[ReflectionObject](http://php.net/manual/zh/class.reflectionobject.php)、[ReflectionMethod](http://php.net/manual/zh/class.reflectionmethod.php)

### [ReflectionClass](http://php.net/manual/zh/class.reflectionclass.php)：报告一个类的有关信息

	ReflectionClass implements Reflector {
		/* 常量 */
		const integer IS_IMPLICIT_ABSTRACT = 16 ;
		const integer IS_EXPLICIT_ABSTRACT = 32 ;
		const integer IS_FINAL = 64 ;
		/* 属性 */
		public $name ;
		/* 方法 */
		public __construct ( mixed $argument )
		public static string export ( mixed $argument [, bool $return = false ] )
		public mixed getConstant ( string $name )
		public array getConstants ( void )
		public ReflectionMethod getConstructor ( void )
		public array getDefaultProperties ( void )
		public string getDocComment ( void )
		public int getEndLine ( void )
		public ReflectionExtension getExtension ( void )
		public string getExtensionName ( void )
		public string getFileName ( void )
		public array getInterfaceNames ( void )
		public array getInterfaces ( void )
		public ReflectionMethod getMethod ( string $name )
		public array getMethods ([ int $filter ] )
		public int getModifiers ( void )
		public string getName ( void )
		public string getNamespaceName ( void )
		public object getParentClass ( void )
		public array getProperties ([ int $filter ] )
		public ReflectionProperty getProperty ( string $name )
		public string getShortName ( void )
		public int getStartLine ( void )
		public array getStaticProperties ( void )
		public mixed getStaticPropertyValue ( string $name [, mixed &$def_value ] )
		public array getTraitAliases ( void )
		public array getTraitNames ( void )
		public array getTraits ( void )
		public bool hasConstant ( string $name )
		public bool hasMethod ( string $name )
		public bool hasProperty ( string $name )
		public bool implementsInterface ( string $interface )
		public bool inNamespace ( void )
		public bool isAbstract ( void )
		public bool isCloneable ( void )
		public bool isFinal ( void )
		public bool isInstance ( object $object )
		public bool isInstantiable ( void )
		public bool isInterface ( void )
		public bool isInternal ( void )
		public bool isIterateable ( void )
		public bool isSubclassOf ( string $class )
		public bool isTrait ( void )
		public bool isUserDefined ( void )
		public object newInstance ( mixed $args [, mixed $... ] )
		public object newInstanceArgs ([ array $args ] )
		public object newInstanceWithoutConstructor ( void )
		public void setStaticPropertyValue ( string $name , string $value )
		public string __toString ( void )
	}

### [ReflectionObject](http://php.net/manual/zh/class.reflectionobject.php)：报告了一个对象（object）的相关信息

	ReflectionObject extends ReflectionClass implements Reflector {
		/* 常量 */
		const integer IS_IMPLICIT_ABSTRACT = 16 ;
		const integer IS_EXPLICIT_ABSTRACT = 32 ;
		const integer IS_FINAL = 64 ;
		/* 属性 */
		public $name ;
		/* 方法 */
		public __construct ( object $argument )
		public static string export ( string $argument [, bool $return ] )
		/* 继承的方法 */
		public ReflectionClass::__construct ( mixed $argument )
		public static string ReflectionClass::export ( mixed $argument [, bool $return = false ] )
		public mixed ReflectionClass::getConstant ( string $name )
		public array ReflectionClass::getConstants ( void )
		public ReflectionMethod ReflectionClass::getConstructor ( void )
		public array ReflectionClass::getDefaultProperties ( void )
		public string ReflectionClass::getDocComment ( void )
		public int ReflectionClass::getEndLine ( void )
		public ReflectionExtension ReflectionClass::getExtension ( void )
		public string ReflectionClass::getExtensionName ( void )
		public string ReflectionClass::getFileName ( void )
		public array ReflectionClass::getInterfaceNames ( void )
		public array ReflectionClass::getInterfaces ( void )
		public ReflectionMethod ReflectionClass::getMethod ( string $name )
		public array ReflectionClass::getMethods ([ int $filter ] )
		public int ReflectionClass::getModifiers ( void )
		public string ReflectionClass::getName ( void )
		public string ReflectionClass::getNamespaceName ( void )
		public object ReflectionClass::getParentClass ( void )
		public array ReflectionClass::getProperties ([ int $filter ] )
		public ReflectionProperty ReflectionClass::getProperty ( string $name )
		public string ReflectionClass::getShortName ( void )
		public int ReflectionClass::getStartLine ( void )
		public array ReflectionClass::getStaticProperties ( void )
		public mixed ReflectionClass::getStaticPropertyValue ( string $name [, mixed &$def_value ] )
		public array ReflectionClass::getTraitAliases ( void )
		public array ReflectionClass::getTraitNames ( void )
		public array ReflectionClass::getTraits ( void )
		public bool ReflectionClass::hasConstant ( string $name )
		public bool ReflectionClass::hasMethod ( string $name )
		public bool ReflectionClass::hasProperty ( string $name )
		public bool ReflectionClass::implementsInterface ( string $interface )
		public bool ReflectionClass::inNamespace ( void )
		public bool ReflectionClass::isAbstract ( void )
		public bool ReflectionClass::isCloneable ( void )
		public bool ReflectionClass::isFinal ( void )
		public bool ReflectionClass::isInstance ( object $object )
		public bool ReflectionClass::isInstantiable ( void )
		public bool ReflectionClass::isInterface ( void )
		public bool ReflectionClass::isInternal ( void )
		public bool ReflectionClass::isIterateable ( void )
		public bool ReflectionClass::isSubclassOf ( string $class )
		public bool ReflectionClass::isTrait ( void )
		public bool ReflectionClass::isUserDefined ( void )
		public object ReflectionClass::newInstance ( mixed $args [, mixed $... ] )
		public object ReflectionClass::newInstanceArgs ([ array $args ] )
		public object ReflectionClass::newInstanceWithoutConstructor ( void )
		public void ReflectionClass::setStaticPropertyValue ( string $name , string $value )
		public string ReflectionClass::__toString ( void )
	}

### [ReflectionMethod](http://php.net/manual/zh/class.reflectionmethod.php)：报告一个方法的有关信息

	ReflectionMethod extends ReflectionFunctionAbstract implements Reflector {
		/* 常量 */
		const integer IS_STATIC = 1 ;
		const integer IS_PUBLIC = 256 ;
		const integer IS_PROTECTED = 512 ;
		const integer IS_PRIVATE = 1024 ;
		const integer IS_ABSTRACT = 2 ;
		const integer IS_FINAL = 4 ;
		/* 属性 */
		public $name ;
		public $class ;
		/* 方法 */
		public __construct ( mixed $class , string $name )
		public static string export ( string $class , string $name [, bool $return = false ] )
		public Closure getClosure ( object $object )
		public ReflectionClass getDeclaringClass ( void )
		public int getModifiers ( void )
		public ReflectionMethod getPrototype ( void )
		public mixed invoke ( object $object [, mixed $parameter [, mixed $... ]] )
		public mixed invokeArgs ( object $object , array $args )
		public bool isAbstract ( void )
		public bool isConstructor ( void )
		public bool isDestructor ( void )
		public bool isFinal ( void )
		public bool isPrivate ( void )
		public bool isProtected ( void )
		public bool isPublic ( void )
		public bool isStatic ( void )
		public void setAccessible ( bool $accessible )
		public string __toString ( void )
		/* 继承的方法 */
		final private void ReflectionFunctionAbstract::__clone ( void )
		public ReflectionClass ReflectionFunctionAbstract::getClosureScopeClass ( void )
		public object ReflectionFunctionAbstract::getClosureThis ( void )
		public string ReflectionFunctionAbstract::getDocComment ( void )
		public int ReflectionFunctionAbstract::getEndLine ( void )
		public ReflectionExtension ReflectionFunctionAbstract::getExtension ( void )
		public string ReflectionFunctionAbstract::getExtensionName ( void )
		public string ReflectionFunctionAbstract::getFileName ( void )
		public string ReflectionFunctionAbstract::getName ( void )
		public string ReflectionFunctionAbstract::getNamespaceName ( void )
		public int ReflectionFunctionAbstract::getNumberOfParameters ( void )
		public int ReflectionFunctionAbstract::getNumberOfRequiredParameters ( void )
		public array ReflectionFunctionAbstract::getParameters ( void )
		public string ReflectionFunctionAbstract::getShortName ( void )
		public int ReflectionFunctionAbstract::getStartLine ( void )
		public array ReflectionFunctionAbstract::getStaticVariables ( void )
		public bool ReflectionFunctionAbstract::inNamespace ( void )
		public bool ReflectionFunctionAbstract::isClosure ( void )
		public bool ReflectionFunctionAbstract::isDeprecated ( void )
		public bool ReflectionFunctionAbstract::isGenerator ( void )
		public bool ReflectionFunctionAbstract::isInternal ( void )
		public bool ReflectionFunctionAbstract::isUserDefined ( void )
		public bool ReflectionFunctionAbstract::isVariadic ( void )
		public bool ReflectionFunctionAbstract::returnsReference ( void )
		abstract public void ReflectionFunctionAbstract::__toString ( void )
	}

# 三、反射获取函数相关信息

## 3.1、核心API：[ReflectionFunction](http://php.net/manual/zh/class.reflectionfunction.php)

### [ReflectionFunction](http://php.net/manual/zh/class.reflectionfunction.php)：报告一个函数的有关信息
	ReflectionFunction extends ReflectionFunctionAbstract implements Reflector {
		/* 常量 */
		const integer IS_DEPRECATED = 262144 ;
		/* 属性 */
		public $name ;
		/* 方法 */
		public __construct ( mixed $name )
		public static string export ( string $name [, string $return ] )
		public Closure getClosure ( void )
		public mixed invoke ([ mixed $parameter [, mixed $... ]] )
		public mixed invokeArgs ( array $args )
		public bool isDisabled ( void )
		public string __toString ( void )
		/* 继承的方法 */
		final private void ReflectionFunctionAbstract::__clone ( void )
		public ReflectionClass ReflectionFunctionAbstract::getClosureScopeClass ( void )
		public object ReflectionFunctionAbstract::getClosureThis ( void )
		public string ReflectionFunctionAbstract::getDocComment ( void )
		public int ReflectionFunctionAbstract::getEndLine ( void )
		public ReflectionExtension ReflectionFunctionAbstract::getExtension ( void )
		public string ReflectionFunctionAbstract::getExtensionName ( void )
		public string ReflectionFunctionAbstract::getFileName ( void )
		public string ReflectionFunctionAbstract::getName ( void )
		public string ReflectionFunctionAbstract::getNamespaceName ( void )
		public int ReflectionFunctionAbstract::getNumberOfParameters ( void )
		public int ReflectionFunctionAbstract::getNumberOfRequiredParameters ( void )
		public array ReflectionFunctionAbstract::getParameters ( void )
		public string ReflectionFunctionAbstract::getShortName ( void )
		public int ReflectionFunctionAbstract::getStartLine ( void )
		public array ReflectionFunctionAbstract::getStaticVariables ( void )
		public bool ReflectionFunctionAbstract::inNamespace ( void )
		public bool ReflectionFunctionAbstract::isClosure ( void )
		public bool ReflectionFunctionAbstract::isDeprecated ( void )
		public bool ReflectionFunctionAbstract::isGenerator ( void )
		public bool ReflectionFunctionAbstract::isInternal ( void )
		public bool ReflectionFunctionAbstract::isUserDefined ( void )
		public bool ReflectionFunctionAbstract::isVariadic ( void )
		public bool ReflectionFunctionAbstract::returnsReference ( void )
		abstract public void ReflectionFunctionAbstract::__toString ( void )
	}

## 3.2、用法

	<?php
	$refFunc = new ReflectionFunction('preg_replace');
	foreach( $refFunc->getParameters() as $param ){
	    //invokes ■ReflectionParameter::__toString
	    print $param;
	}
	?>
	
	prints:
	
	Parameter #0 [ <required> $regex ]
	Parameter #1 [ <required> $replace ]
	Parameter #2 [ <required> $subject ]
	Parameter #3 [ <optional> $limit ]
	Parameter #4 [ <optional> &$count ]