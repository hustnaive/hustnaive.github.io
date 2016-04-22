---
layout: page
title: foreach中&引用问题
categories: php
tags: php
---

最近有同事碰到一个很怪异的场景，跑到我这里问，我也琢磨半天，结合百度搜索才明白原因。

先来看看问题代码：

```php

$a = ['a'=>1,'b'=>['c'=>2],'d'=>3,'e'=>4];

foreach($a as $k=>&$v) {

}

print_r($a);

foreach($a as $k =>$v) {
    
}

print_r($a);

```

很简单的代码，但是输出很诡异：

```php

Array
(
    [a] => 1
    [b] => Array
        (
            [c] => 2
        )

    [d] => 3
    [e] => 4
)
Array
(
    [a] => 1
    [b] => Array
        (
            [c] => 2
        )

    [d] => 3
    [e] => 3
)

```

看到没有，数组的最后一个元素被改变了。 看了网上别人的解释，琢磨半天，总算明白是个什么意思。

在<http://php.net/manual/zh/control-structures.foreach.php> 这里，有一个警告:

>Warning
数组最后一个元素的 `$value` 引用在 `foreach` 循环之后仍会保留。建议使用 `unset()` 来将其销毁。

什么意思呢，就是在 `foreach` 遍历结束后，我们的临时变量 `$k`, `$v` 仍然保留，指向最后一个遍历元素。那么，如果我们的 `$v` 是一个引用的话，那在后面直接对其进行操作的话，是会产生问题的。所以，这里PHP建议你将其 `unset` 掉。

怎么理解呢？下面我们调整上上述代码，在循环体里面输出一下 `$a` 的值：

```php

$a = [ 'a'=>1, 'b'=>[ 'c'=>2], 'd'=>3, 'e'=>4];

foreach($a as $k=>&$v) {

}

echo "after first round of foreach \$k = '$k ', \$v = '$v'" .PHP_EOL;

echo PHP_EOL.'the next round of foreach' .PHP_EOL;

foreach($a as $k=>$v) {
    echo PHP_EOL.'key: '.$k.PHP_EOL;
    print_r($a );
}

```

我们看一下输出：

```php

after first round of foreach $k = 'e', $v = '4'

the next round of foreach

key: a
Array
(
    [a] => 1
    [b] => Array
        (
            [c] => 2
        )

    [d] => 3
    [e] => 1
)

key: b
Array
(
    [a] => 1
    [b] => Array
        (
            [c] => 2
        )

    [d] => 3
    [e] => Array
        (
            [c] => 2
        )

)

key: d
Array
(
    [a] => 1
    [b] => Array
        (
            [c] => 2
        )

    [d] => 3
    [e] => 3
)

key: e
Array
(
    [a] => 1
    [b] => Array
        (
            [c] => 2
        )

    [d] => 3
    [e] => 3
)


```

在第一轮遍历结束后 `$v` 指向 `$a` 的最后一个元素的地址（引用），那么在第二轮遍历的时候，是会把 `$a` 的每个元素分别赋值给 `$v`，也就是 `$a` 的最后一个元素。 所以就产生了我们看到的场景。

这里，建议大家在使用foreach的时候慎用&，使用完后，要记得unset调这个变量。不然会产生各种诡异的问题。