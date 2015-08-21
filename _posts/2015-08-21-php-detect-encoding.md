---
layout: page
title: PHP检测字符编码
categories: php
tags: php
---

在一个文档预览服务里面，我需要探测字符串（文件）的编码集，并根据编码集输出正确的header信息。

一般的做法是用`mb_detect_encoding`来进行探测，但是这个探测的误报率比较高，经常容易探测不出来准确的字符集。因为时间关系没有细研究`mb_detect_encoding`异常的原因，我自己实现了一个`detect_charset`的方法（见后）。

但是，在开始之前，我们需要有一些知识准备：

内码
---

我们知道任何字符串在某个计算机系统中都是以01形式存储，这个01二进制流就是内码。

比如 `$a = 'ab'`，这里字符串`ab`在内存里面存储的大概为`0x61 0x62`这种形式的二进制数据（根据不同的编码集，具体占用的字节数可能不一样，中间会有一些补零）。

在计算机内部进行数据流转的时候，其实是内码的传输拷贝。比如`file_put_content($a)`就是把`ab`字符串对应的二进制内码写入到文件中，而非其字符图片的二进制数据。


编码集
---

编码集就是计算机内码所使用的编码规则，为什么要有这个规则呢？

如果没有编码集，我们如何表示一个字符串，比如字符`a`？ 我们知道计算机只能识别一个二进制流，如果不用编码集，我们如何用图形化的方式表示字符`a`？

比如，我们用一个8x8的格子用点状来描绘`a`:

	. . . . . . . .
	. * * * * . . .
	. . * * * * . .
	. * . . . * . .
	. * . . . * . .
	. * . . . * * *
	. . * * * . . .
	. . . . . . . .


这里，就是一个图形化的`a`，虽然不是很像，但是已经有`a`的雏形了。那么，如果把这个转换为计算机可以识别的形式呢？

我们用0代表`.`，1代表`*`，上面的格子可以转换为：

	0 0 0 0 0 0 0 0
	0 1 1 1 1 0 0 0
	0 0 1 1 1 1 0 0
	0 1 0 0 0 1 0 0
    0 1 0 0 0 1 0 0
    0 1 0 0 0 1 1 1
    0 0 1 1 1 0 0 0
    0 0 0 0 0 0 0 0

这样，我们就可以用8x8=64个二进制位来存储，即8字节来存储这个点图。

`bcd...`同理。

这种编码方式其实也是一种编码集，但是，我们的计算机其实不是这样的。为什么不用这种编码方式呢？后面我们可以看到这种编码方式会有很多的冗余，而且不利于扩展，比如中文的字符'的'用这种方式如何编码？可能8x8的格子就已经不够用了。

最早期的ASCII编码是这样做的：

因为拉丁文常用字符`a-zA-Z`只有52个不同的字符，那么我们用数字`1-52`就可以分别代表这52个字符，而数字`1-52`只需要一个字节就可以存储。因为一个字节的存储范围为0~255。

所以，实际上ASCII用0x61代表字符`a`，其他的以此类推。这就是ASCII编码集，它的内码范围为`0x00-0x7f`。

但是，随着计算机的传播跟发展，我们发现其他国家的语言没法用这个编码集来表示。这个时候，不同国家的人就不得不制定新的扩展集，来表示自己国家的文字字符。

比如，我们中文，就有gbk,big5,gb2310之类的编码集。


```php

	/**
     * 检测字符串编码（注意：存在误判的可能性，降低误判的几率的唯一方式是给出尽可能多的样本$line）
     * 检测原理：对给定的字符串的每一个字节进行判断，如果误差与gb18030在指定误差内，则判定为gb18030；与utf-8在指定误差范围内，则判定为utf-8；否则判定为utf-16
     * @param string $line
     * @return string 中文字符集，返回gb18030（兼容gbk,gb2312,ascii）；西文字符集，返回utf-8（兼容ascii）；其他，返回utf-16（双字节unicode）
     * @author fangl
     */
    function detect_charset($line) {
        if(self::detect_gb18030($line)) {
            return 'gb18030';
        }
        else if(self::detect_utf8($line)) {
            return 'utf-8';
        }
        else return 'utf-16';
    }
    
    /**
     * 兼容ascii，gbk gb2312，识别字符串是否是gb18030标准的中文编码
     * @param string $line
     * @return boolean
     * @author fangl
     */
    function detect_gb18030($line) {
        $gbbyte = 0; //识别出gb字节数
        for($i=0;$i+3<strlen($line);) {
            if(ord($line{$i}) >= 0 && ord($line{$i}) <= 0x7f) {
                $gbbyte ++; //识别一个单字节 ascii
                $i++;
            }
            else if( ord($line{$i}) >= 0x81 && ord($line{$i}) <= 0xfe &&
            (ord($line{$i+1}) >= 0x40 && ord($line{$i+1}) <= 0x7e ||
             ord($line{$i+1}) >= 0x80 && ord($line{$i+1}) <= 0xfe) ) {
                $gbbyte += 2; //识别一个双字节gb18030（gbk）
                $i += 2;
            }
            else if( ord($line{$i}) >= 0x81 && ord($line{$i}) <= 0xfe &&
            ord($line{$i+2}) >= 0x81 && ord($line{$i+2}) <= 0xfe &&
            ord($line{$i+1}) >= 0x30 && ord($line{$i+1}) <= 0x39 &&
            ord($line{$i+3}) >= 0x30 && ord($line{$i+3}) <= 0x39) {
                $gbbyte += 4; //识别一个4字节gb18030（扩展）
                $i += 4;
            }
            else $i++; //未识别gb18030字节
        }
        return abs($gbbyte - strlen($line)) <= 4; //误差在4字节之内
    }
    
    /**
     * 识别字符串是否是utf-8编码，同样兼容ascii
     * @param string $line
     * @return boolean
     * @author fangl
     */
    function detect_utf8($line) {
        $utfbyte = 0; //识别出utf-8字节数
        for($i=0;$i+2<strlen($line);) {
            //单字节时，编码范围为：0x00 - 0x7f
            if(ord($line{$i}) >= 0 && ord($line{$i}) <= 0x7f) {
                $utfbyte ++; //识别一个单字节utf-8（ascii）
                $i++;
            }
            //双字节时，编码范围为：高字节 0xc0 - 0xcf 低字节 0x80 - 0xbf
            else if(ord($line{$i}) >= 0xc0 && ord($line{$i}) <= 0xcf
            && ord($line{$i+1}) >= 0x80 && ord($line{$i+1}) <= 0xbf) {
                $utfbyte += 2; //识别一个双字节utf-8
                $i += 2;
            }
            //三字节时，编码范围为：高字节 0xe0 - 0xef 中低字节 0x80 - 0xbf
            else if(ord($line{$i}) >= 0xe0 && ord($line{$i}) <= 0xef
            && ord($line{$i+1}) >= 0x80 && ord($line{$i+1}) <= 0xbf
            && ord($line{$i+2}) >= 0x80 && ord($line{$i+2}) <= 0xbf) {
                $utfbyte += 3; //识别一个三字节utf-8
                $i += 3;
            }
            else $i++; //未识别utf-8字节
        }
        return abs($utfbyte - strlen($line)) <= 3; //误差在3字节之内的，则识别为utf-8编码
    }

```