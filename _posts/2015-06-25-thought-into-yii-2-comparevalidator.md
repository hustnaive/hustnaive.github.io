---
layout: page
title: Yii 2 CompareValidator的一点思考
categories: yii php
tags: yii2
---

Yii 2 CompareValidator的一点思考
===

起因是YiiChina社区里的一个问题：

	为什么用compareAttribute验证两个密码是否一致时,我两个密码输入是个数不同的0时,验证通过了? 
	array('pwd2', 'compare', 'compareAttribute' => 'password', 'message' => '两次密码必须一致'),

看了下`CompareValidator`的实现，发现针对字符串的比较处理上，确实有待商榷的地方。

 	/**
     * Compares two values with the specified operator.
     * @param string $operator the comparison operator
     * @param string $type the type of the values being compared
     * @param mixed $value the value being compared
     * @param mixed $compareValue another value being compared
     * @return boolean whether the comparison using the specified operator is true.
     */
    protected function compareValues($operator, $type, $value, $compareValue)
    {
        if ($type === 'number') {
            $value = (float) $value;
            $compareValue = (float) $compareValue;
        } else {
            $value = (string) $value;
            $compareValue = (string) $compareValue;
        }
        switch ($operator) {
            case '==':
                return $value == $compareValue;
            case '===':
                return $value === $compareValue;
            case '!=':
                return $value != $compareValue;
            case '!==':
                return $value !== $compareValue;
            case '>':
                return $value > $compareValue;
            case '>=':
                return $value >= $compareValue;
            case '<':
                return $value < $compareValue;
            case '<=':
                return $value <= $compareValue;
            default:
                return false;
        }
    }

这里，无论是数值还是字符串的比较，都是用的比较运算符。

其实针对字符串比较的时候，如果用比较运算符而非比较函数（strcmp）时，当比较的字符串为含有前导0的数字字符串的时候是会有问题的。

比如：'001' == '01','000' == '00'，都是为"真"。因为用比较运算符对可以转换为数值的纯数字字符串'001'和'01'进行比较时，它们会被自动的转换为数值1进行比较，这个时候，它们值相等，测试代码：

	if('00' == '0') {
	    echo '==';
	}
	else echo '!=';

这里，对compareValues做了调整，针对'==','!=','>','<','>=','<='的几种场景，用strcmp。注意对于'===','!=='时因为值和类型一起比较，所以没法使用strcmp。

调整后的代码为：

	/**
     * Compares two values with the specified operator.
     * @param string $operator the comparison operator
     * @param string $type the type of the values being compared
     * @param mix $value the value being compared
     * @param mix $compareValue another value being compared
     * @return boolean whether the comparison using the specified operator is true.
     */
    protected function compareValues($operator, $type, $value, $compareValue) 
    {
        if($this->type === 'number') {
            return $this->compareNumbericValues($operator, $type, $value, $compareValue);
        }
        else return $this->compareStringValues($operator, $type, $value, $compareValue);
    }
    /**
     * Compares two numberic values with the specified operator.
     * @param string $operator the comparison operator
     * @param string $type the type of the values being compared
     * @param numberic $value the value being compared
     * @param numberic $compareValue another value being compared
     * @return boolean whether the comparison using the specified operator is true.
     */
    protected function compareNumbericValues($operator, $type, $value, $compareValue)
    {
        $value = (float) $value;
        $compareValue = (float) $compareValue;
        
        switch ($operator) {
            case '==':
                return $value == $compareValue;
            case '===':
                return $value === $compareValue;
            case '!=':
                return $value != $compareValue;
            case '!==':
                return $value !== $compareValue;
            case '>':
                return $value > $compareValue;
            case '>=':
                return $value >= $compareValue;
            case '<':
                return $value < $compareValue;
            case '<=':
                return $value <= $compareValue;
            default:
                return false;
        }
    }
    
    /**
     * Compares two string values with the specified operator.
     * @param string $operator the comparison operator
     * @param string $type the type of the values being compared
     * @param mix $value the value being compared
     * @param mix $compareValue another value being compared
     * @return boolean whether the comparison using the specified operator is true.
     */
    protected function compareStringValues($operator, $type, $value, $compareValue)
    {
        $value = (string) $value;
        $compareValue = (string) $compareValue;
        switch ($operator) {
            case '==':
                return strcmp($value, $compareValue) == 0;
            case '===':
                return $value === $compareValue;
            case '!=':
                return strcmp($value, $compareValue) != 0;
            case '!==':
                return $value !== $compareValue;
            case '>':
                return strcmp($value, $compareValue) > 0;
            case '>=':
                return strcmp($value, $compareValue) >= 0;
            case '<':
                return strcmp($value, $compareValue) < 0;
            case '<=':
                return strcmp($value, $compareValue) <= 0;
            default:
                return false;
        }
    }

经过测试，修复了上述问题。

---

* GitHub上给官方提了一个Issue：<https://github.com/yiisoft/yii2/issues/8884>
* YiiChina上的原问题：<http://www.yiichina.com/question/644>