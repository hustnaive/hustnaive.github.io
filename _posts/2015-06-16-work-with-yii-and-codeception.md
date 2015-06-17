---
layout: page
title: Composer包管理器介绍
categories: php
tags: php
---

Yii2和CodeCeption
========

CodeCeption是一个全栈的PHP测试框架，关于CodeCeption的介绍见：[CodeCeption官方文档](https://github.com/Codeception/Codeception/tree/2.0/docs)。

Yii2官方增加了对CodeCeption的支持，这里主要讲解Yii2里如何基于CodeCeption进行单元测试和功能测试。

知识准备
----

* Composer基础：[Composer官方文档](http://docs.phpcomposer.com/00-intro.html)
* CodeCeption基础：[CodeCeption官方文档](https://github.com/Codeception/Codeception/tree/2.0/docs)
* Yii2-app-basic中的CodeCeption例子：[yii2-app-basic](https://github.com/yiisoft/yii2-app-basic/blob/master/tests/README.md)
* Yii2-app-basic项目的地址：<https://github.com/yiisoft/yii2-app-basic>

执行后面操作的前提是本地已经正确安装配置composer。

通过脚手架开始一个Yii2项目
---

通过Composer，我们可以很简单的在本地基于脚手架创建一个Yii2项目：

* 进入一个可以通过web服务器访问的目录：`cd <webroot>`
* 执行：`composer global require "fxp/composer-asset-plugin:~1.0.0"` 命令验证必须插件是否全局安装
* 执行：`composer create-project yiisoft/yii2-app-basic basic` 命令在当前目录的basic目录创建一个"yiisoft/yii2-app/basic"脚手架项目。注意，如果是本地开发环境，你也可以增加`--prefer-dist --stability=dev`选项，参考[stability选项](https://github.com/5-say/composer-doc-cn/blob/master/cn-introduction/04-schema.md#minimum-stability)。

通过以上操作，你的本地目录应该大致如下：

	webroot/basic
		|--- assets/
		|--- commands/
		|--- config/
		|--- controllers/
		|--- mail/
		|--- models/
		|--- runtime/
		|--- tests/
		|--- vendor/
		|--- views/
		|--- web/
		|--- .gitignore
		|--- composer.json
		|--- composer.lock
		...

其中，tests就是框架默认创建的测试代码目录，里面有框架提供的一些测试的例子，你可以按如下步骤测试一下：

* `cd basic/tests/` 进入CodeCeption测试用例所在目录
* `codecept build`  将构建测试用例（根据cept生成tester）   
* `codecept run`    运行测试用例

如果你终端提示codecept命令未知，请执行以下命令安装codeception扩展：

	composer global require "codeception/codeception=2.0.*"
	composer global require "codeception/specify=*"
	composer global require "codeception/verify=*"
	composer require --dev yiisoft/yii2-faker:*

正常安装后，再执行`codecept run`时，如果看到类似如下的报错：

	1) Failed to ensure that about works in [1mAboutCept[22m (D:\php\basic\tests\codeception\acceptance\AboutCept.php)
	Can't be on page "/index-test.php?r=site%2Fabout":
	GuzzleHttp\Exception\ConnectException: cURL error 7: Failed to connect to localhost port 8080: Connection refused

提示在8080端口连接拒绝，这里，我们需要修改一下配置文件:

* 修改`basic/tests/codeception.yml`里面的`config/test_entry_url`配置，为你实际的项目入口地址
* 修改`basic/tests/codeception/acceptance.suite.yml`里面的`modules/config/PhpBrowser`配置为你实际的地址

完成后，再执行`codecept run`，你应该可以看到终端没有报错了。

我们来看看tests目录的结构：

	webroot/basic/tests
		|--- codeception/
		|		|--- _output/
		|		|--- _pages/
		|		|--- acceptance/
		|		|--- bin/
		|		|--- config/
		|		|--- fixtures/
		|		|--- functional/
		|		|--- templates/
		|		|--- unit
		|		|--- _bootstrap.php
		|		|--- acceptance.suite.yml
		|		|--- functional.suite.yml
		|		|--- unit.suite.yml
		|--- codeception.yml

其实，这里acceptance、functional、unit是Yii2默认为我们创建的三个suite，顾名思义，分别用于验收，功能，单元测试。

而执行`codecept run`时，会依次将codeception目录的所有suite运行，故，你可以通过`codecept run suitename`的方式制定执行某个suite；同理，可以执行`codecept run suitename testname`的方式执行某个test。

你可以仿照functional，unit，acceptance里面的例子写你自己的测试用例。

> 注：通过脚手架创建的Yii2项目会自动增加gitignore，将vendor中的内容从版本库中忽略，如果你需要提交，请手动修改gitignore文件。


从已有的Yii2项目开始CodeCeption
---

对于一个已有的Yii2项目，我们需要遵循如下几步来配置CodeCeption。

* 在项目根目录执行`composer init`来初始化composer。
* 执行如下指令确保codeception的扩展包已经全局安装
	* `composer global require "codeception/codeception=2.0.*"`
	* `composer global require "codeception/specify=*"`
	* `composer global require "codeception/verify=*"`
	* `composer require --dev yiisoft/yii2-faker:*`
* 在项目合适的目录创建一个codeception目录作为codeception的测试代码目录
* 进入codeception目录，执行`codecept bootstrap`来初始化生成测试代码脚手架。
* 仿照yii2-app-basic，修改codeception.yml
* 仿照yii2-app-basic，修改codeception/tests/_bootstrap.php文件
* 仿照yii2-app-basic，修改codeception/tests/*.suite.yml
* 增加一个codeception/tests/config目录，以存储配置文件。仿照yii2-app-basic的形式增加config.php,common.php

> 具体的配置内容依实际情况而定，具体可以参考yii2-app-basic提供的例子。

以ydxs为例，如何新建一个针对demo模块的测试
---

>关于demo模块的具体代码，参见[Yii云客PHP开发入门](https://git.mysoft.com.cn/ydxs_group/ydxs/blob/master/docs/PHP%E5%BC%80%E5%8F%91%E5%B8%AE%E5%8A%A9/Yii%E4%BA%91%E5%AE%A2PHP%E5%BC%80%E5%8F%91%E5%85%A5%E9%97%A8.md)。本例是基于此文的基础上，在完成demo模块的代码后增加基于CodeCeption的测试代码。
>
>假设本地的代码基于ydxs/ydxs\_branch\_wh分支，代码本地目录为[[ydxs]]，部署的域为[[http://localhost:8002]]，并按照[[Yii云客PHP开发入门]]文档的示例完成demo模块的开发工作。
> 
> 注：最好你能够把`BaseController`中的`exit`用`Yii::$app->end()`代替，不然在后面运行测试用例的时候，会发生不可意料的问题。

在开始之前，我们在项目根目录ydxs下执行`git checkout -b codeceptiontest`，新建一个`codeceptiontest`分支，避免污染本地代码。

## 基本的配置初始化

### 1、初始化composer

在ydxs(codeceptiontest)目录执行`composer init`指令初始化composer

### 2、确保全局依赖包安装

在ydxs目录执行：

* `composer global require "codeception/codeception=2.0.*"`
* `composer global require "codeception/specify=*"`
* `composer global require "codeception/verify=*"`
* `composer require --dev yiisoft/yii2-faker:*`

### 3、初始化codeception

* 在ydxs/website/tests目录创建codeception目录，作为codeception的代码目录。
* `cd codeception`，执行`codecept bootstrap`，产生初始化代码
* 修改`codeception/codeception.yml`，内容见后。
* 修改`codeception/tests/_bootstrap.php`，内容见后。
* 修改`codeception/tests/functional.suite.yml`，内容见后。
* 新建`codeception/tests/config`目录，添加common.php,config.php，内容见后。

codeception/codeception.yml
---
	actor: Tester
	paths:
	    tests: tests
	    log: tests/_output
	    data: tests/_data
	    helpers: tests/_support
	settings:
	    bootstrap: _bootstrap.php
	    colors: false
	    memory_limit: 1024M
	config:
	    test_entry_url: http://localhost:8002/index.php
	modules:
	    config:
	        Db:
	            dsn: ''
	            user: ''
	            password: ''
	            dump: tests/_data/dump.sql

codeception/tests/_bootstrap.php
---
	<?php
	defined('YII_DEBUG') or define('YII_DEBUG', true);
	defined('YII_ENV') or define('YII_ENV', 'test');
	
	//web根目录（/website目录）
	defined('WEBROOT') or define('WEBROOT',dirname(dirname(dirname(__DIR__))));
	
	//扩展根目录
	defined('VENDOR_PATH') or define('VENDOR_PATH',dirname(WEBROOT).'/vendor');
	
	require_once(VENDOR_PATH. '/autoload.php');
	require_once(VENDOR_PATH. '/yii2/Yii.php');
	
	define('YII_TEST_ENTRY_URL', parse_url(\Codeception\Configuration::config()['config']['test_entry_url'], PHP_URL_PATH));
	define('YII_TEST_ENTRY_FILE', WEBROOT. '/index.php');
	
	$_SERVER['SCRIPT_FILENAME'] = YII_TEST_ENTRY_FILE;
	$_SERVER['SCRIPT_NAME'] = YII_TEST_ENTRY_URL;
	$_SERVER['SERVER_NAME'] = parse_url(\Codeception\Configuration::config()['config']['test_entry_url'], PHP_URL_HOST);
	$_SERVER['SERVER_PORT'] =  parse_url(\Codeception\Configuration::config()['config']['test_entry_url'], PHP_URL_PORT) ?: '80';
	$_SERVER['HTTP_HOST'] = parse_url(\Codeception\Configuration::config()['config']['test_entry_url'], PHP_URL_HOST);
	
	//是否启用缓存，默认开启 true
	defined('YII_ENABLE_CACHE') or define('YII_ENABLE_CACHE', true);
	
	//各个别名目录
	Yii::setAlias('@tests', dirname(__DIR__));
	
	Yii::setAlias("@modules",WEBROOT.'/modules');
	
	Yii::setAlias("@services",dirname(WEBROOT) .'/services' );
	Yii::setAlias('@dbaccess',dirname(WEBROOT).'/dbaccess' );
	Yii::setAlias('@models',dirname(WEBROOT).'/models' );
	
	Yii::setAlias("@yunke",  VENDOR_PATH.'/yunke');
	Yii::setAlias('@webUrl', 'http://'.$_SERVER['HTTP_HOST'] );
	Yii::setAlias("@webRoot", WEBROOT);
	Yii::setAlias("@InfluxPHP",  VENDOR_PATH.'/InfluxPHP');
	Yii::setAlias("@Pinq",  VENDOR_PATH.'/Pinq');
	Yii::setAlias("@Oauth",  VENDOR_PATH.'/Oauth');
	
	/*加载功能函数*/
	require(VENDOR_PATH . '/yunke/functions.php');


codeception/tests/functional.suite.yml
---
	# Codeception Test Suite Configuration
	
	# suite for functional (integration) tests.
	# emulate web requests and make application process them.
	# Include one of framework modules (Symfony2, Yii2, Laravel5) to use it.
	
	class_name: FunctionalTester
	modules:
	    enabled:       
	      - Filesystem
	      - Yii2
	      - REST
	    config:
	        Yii2:
	            configFile: 'tests/config/common.php'

codeception/tests/config/common.php
---
	<?php
	$_SERVER['SCRIPT_FILENAME'] = YII_TEST_ENTRY_FILE;
	$_SERVER['SCRIPT_NAME'] = YII_TEST_ENTRY_URL;
	//这里为什么要重复定义？（而且还非不可）
	
	/**
	 * Application configuration for functional tests
	 */
	return yii\helpers\ArrayHelper::merge(
	    require(__DIR__ . '/../../../../config/web.php'),
	    require(__DIR__ . '/config.php'),
	    [
	        'components' => [
	            'request' => [
	                // it's not recommended to run functional tests with CSRF validation enabled
	                'enableCsrfValidation' => false,
	                // but if you absolutely need it set cookie domain to localhost
	                /*
	                'csrfCookie' => [
	                    'domain' => 'localhost',
	                ],
	                */
	            ],
	        ],
	    ]
	);


codeception/tests/config/config.php
---
	<?php
	/**
	 * Application configuration shared by all test types
	 */
	return [
	    'controllerMap' => [
	        'fixture' => [
	            'class' => 'yii\faker\FixtureController',
	            'fixtureDataPath' => '@tests/codeception/fixtures',
	            'templatePath' => '@tests/codeception/templates',
	            'namespace' => 'tests\codeception\fixtures',
	        ],
	    ],
	    'components' => [
	//         'db' => [
	//             'dsn' => 'mysql:host=localhost;dbname=yii2basic_tests',
	//         ],
	//         'mailer' => [
	//             'useFileTransport' => true,
	//         ],
	//         'urlManager' => [
	//             'showScriptName' => true,
	//             'enablePrettyUrl' => false,
	//         ],
	    ],
	];


## 单元测试

单元测试可以通过命令生成模板代码。

* `codecept generate:phpunit unit demo`，在suite:unit下面生成一个demoTest.php。
* 访问[[codeception/tests/unit/demoTest.php]]可以看到CodeCeption已经生成了一个单元测试框架代码，你可以在里面编写自己的单元测试用例。
* 这里，我们直接把demo中对SuserService的测试代码搬过来。

> 在开始之前，我们需要修改codeception/tests/unit/_bootstrap.php，在这里初始化一个[[yii\web\Application]]实例。因为我们的Service里面引用了Yii::$app->db，这要求Yii::$app必须先初始化。

codeception/tests/unit/_bootstrap.php
---
	<?php
	new yii\web\Application(require(dirname(__DIR__). '/config/common.php'));
	//因为需要引用Yii::$app->db等，所以这里需要创建一个Applicaton

codeception/tests/unit/demoTest.php
---
	<?php
	
	use services\demo\SuserService;
	
	class demoTest extends \PHPUnit_Framework_TestCase
	{
	    private $usersrv;
	
	    private $test_uinfo = ['user_code'=>'testusercode','openid'=>'testopenid','password'=>'testpassword','user_name'=>'testusername'];
	
	    public function setUp() {
	        $this->usersrv = new SuserService("defaultorganization");
	    }
	
	    public function test_lstUser() {
	        $this->assertCount(10,$this->usersrv->lstUser(1, 10));
	        $this->assertEmpty($this->usersrv->lstUser(100, 10));
	    }
	
	    public function test_userCRUD() {
	        //测试增加用户
	        $userid = $this->usersrv->updateOrAddUser($this->test_uinfo);
	        $this->assertNotEmpty($userid);  
	
	        //测试查询用户
	        $userinfo = $this->usersrv->findUser($userid);
	        $this->assertNotEmpty($userinfo); 
	        foreach($this->test_uinfo as $k=>$v) {
	            $this->assertEquals($this->test_uinfo[$k],$v);
	        }
	
	        //测试更新用户
	        $userinfo['openid'] = "testopenid2";
	        $this->usersrv->updateOrAddUser($userinfo);
	        $userinfo = $this->usersrv->findUser($userid);
	        $this->assertFalse($userinfo['openid'] == $this->test_uinfo['openid']);
	        $this->assertEquals("testopenid2",$userinfo['openid']);
	
	        //测试删除用户
	        $this->usersrv->delUser($userid); 
	        $userinfo = $this->usersrv->findUser($userid);
	        $this->assertEmpty($userinfo);
	    }
	
	    public function tearDown() {
	        echo "end of test".PHP_EOL;
	    }
	
	}


* 运行`codecept run unit demoTest`就可以执行demoTest测试用例。

## 功能测试

功能测试也可以通过命令模板生成。

* `codecept generate:cept functional demo`，在suite:functional下面生成一个demoCept.php。
* 访问[[codeception/tests/functional/demoCept.php]]可以看到CodeCeption已经生成了一个功能测试框架代码，你可以在里面编写自己的功能测试用例。
* 这里，我们直接把demo的CRUD操作模拟如下：

codeception/tests/functional/demoCept.php
---
	<?php 
	$I = new FunctionalTester($scenario);
	$I->wantTo('测试demo的用户列表，添加，删除操作');
	$I->amOnPage("defaultorganization/demo/index/index?proj_id=1");
	$I->see('loadPage');
	$I->seeLink('上一页');
	$I->seeLink("添加");
	
	$I->amGoingTo("添加一个新的用户");
	$I->click("添加");
	$I->see("添加业务员");
	$user_code = 'test_usercode'.time();
	$I->fillField("user_code", $user_code);
	$I->fillField("openid", "test_openid");
	$I->fillField("user_name", "test_user_name");
	$I->fillField("mobile_tel", "test_mobile_tel");
	$I->click("保存");
	
	$I->amGoingTo("ajax请求用户列表，并看到刚刚添加的用户"); //以下API由REST模块提供
	$I->sendGET("/defaultorganization/demo/index/lstuser?proj_id=1&page=1&pagesize=1");
	$I->seeResponseIsJson(); 
	$I->seeResponseContains('"isSuccess":1');
	$I->seeResponseContains('"user_code":"'.$user_code.'"');
	
	$I->amGoingTo("从ajax的response中把s_userid抓取出来");
	$response = json_decode($I->grabResponse(),true);
	$s_userId = $response['result']['usrlst'][0]['s_userId'];
	
	$I->amGoingTo("删除前面添加的用户：{$s_userId}");
	$I->sendGET("/defaultorganization/demo/index/del?proj_id=1&uid={$s_userId}");
	$I->seeResponseIsJson();
	$I->seeResponseContains('"isSuccess":1');

## 验收测试&&其他CodeCeption的高级用法

acceptance需要跟WebDriver和Selenium协同，这个主要是面向测试人员的。

关于CodeCeption更高级的用法，请参考[CodeCeption官方文档](https://github.com/Codeception/Codeception/tree/2.0/docs)


---


附：如何基于yii2-app-basic按照module来组织项目代码
===

前面所述，通过脚手架创建yii2-app-basic开发环境后，我们的代码目录结构为：

	webroot/basic
		|--- assets/
		|--- commands/
		|--- config/
		|--- controllers/
		|--- mail/
		|--- models/
		|--- runtime/
		|--- tests/
		|--- vendor/
		|--- views/
		|--- web/
		|--- .gitignore
		|--- composer.json
		|--- composer.lock
		...

这个结构是Yii2默认创建的目录，我们可以看到它并没有安装module进行划分。我们可以对其进行调整：

* 新建一个modules目录，假设默认的module为demo
* 在modules目录下面新建demo目录作为demo模块代码存放目录
* 将上面的controllers，models，views三个目录移到demo目录下面
* 在demo目录下新建一个Module.php，新建一个类继承自[[\yii\base\Module]],代码见后。
* 在config目录下面增加一个modules.php，增加对demo目录的配置
* 修改web.php，增加对modules.php的引用
* 修改index.php，增加@modules的别名
* 对应调整modules/demo/里面的namespace


按照以上步骤调整后的路径如下：

	webroot/basic
		|--- assets/
		|--- commands/
		|--- config/
		|--- modules/
		|		|--- demo/
		|		|		|--- controllers/
		|		|		|--- views/
		|		|		|--- models/
		|		|--- ...
		|--- mail/
		|--- runtime/
		|--- tests/
		|--- vendor/
		|--- web/
		|--- .gitignore
		|--- composer.json
		|--- composer.lock
		...

各文件的内容如下：

basic/modules/demo/Module.php
---
	<?php
	 /**
	  * Module.php
	  *
	  * @author        fangliang
	  * @create_time	   2015-06-16
	  */
	
	namespace modules\demo;
	
	
	class Module extends \yii\base\Module
	{
	    public $layout = "main";
	    public $controllerNamespace = 'modules\demo\controllers';
	
	    public function init()
	    {
	        parent::init();
	        //do something init here
	    }
	} 

basic/web/index.php
---
	<?php
	
	// comment out the following two lines when deployed to production
	defined('YII_DEBUG') or define('YII_DEBUG', true);
	defined('YII_ENV') or define('YII_ENV', 'dev');
	
	require(__DIR__ . '/../vendor/autoload.php');
	require(__DIR__ . '/../vendor/yiisoft/yii2/Yii.php');
	
	$config = require(__DIR__ . '/../config/web.php');
	
	Yii::setAlias("@modules",dirname(__DIR__) .'/modules' );
	
	(new yii\web\Application($config))->run();



basic/config/web.php
---
	<?php
	
	$params = require(__DIR__ . '/params.php');
	
	$config = [
	    'id' => 'basic',
	    'basePath' => dirname(__DIR__),
	    'bootstrap' => ['log'],
	    'components' => [
	        'request' => [
	            // !!! insert a secret key in the following (if it is empty) - this is required by cookie validation
	            'cookieValidationKey' => '0_wkmOLxql9rlIaqjYNPFL3pYDfLNuLk',
	        ],
	        'cache' => [
	            'class' => 'yii\caching\FileCache',
	        ],
	        'user' => [
	            'identityClass' => 'modules\demo\models\User',
	            'enableAutoLogin' => true,
	        ],
	        'errorHandler' => [
	            'errorAction' => 'demo/site/error',
	        ],
	        'mailer' => [
	            'class' => 'yii\swiftmailer\Mailer',
	            // send all mails to a file by default. You have to set
	            // 'useFileTransport' to false and configure a transport
	            // for the mailer to send real emails.
	            'useFileTransport' => true,
	        ],
	        'log' => [
	            'traceLevel' => YII_DEBUG ? 3 : 0,
	            'targets' => [
	                [
	                    'class' => 'yii\log\FileTarget',
	                    'levels' => ['error', 'warning'],
	                ],
	            ],
	        ],
	        'db' => require(__DIR__ . '/db.php'),
	    ],
	    'params' => $params,
	    'modules'=> require(__DIR__.'/modules.php'),
	];
	
	if (YII_ENV_DEV) {
	    // configuration adjustments for 'dev' environment
	    $config['bootstrap'][] = 'debug';
	    $config['modules']['debug'] = 'yii\debug\Module';
	
	    $config['bootstrap'][] = 'gii';
	    $config['modules']['gii'] = 'yii\gii\Module';
	}
	
	return $config;


basic/config/modules.php
---
	<?php
	
	return [
	    'demo' =>[
	        'class'=>'modules\demo\Module',
	    ]
	];

在完成以上的配置后，基本的配置就完成了。

如果是一个全新的项目，你可以遵循我的另外一篇指示来搭建模块化的Yii 2 Web应用程序。[Yii2模块化Web应用脚手架](https://github.com/hustnaive/yii2-app-modular)。