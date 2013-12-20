---
layout: post
title: "规则描述语言"
description: ""
category: 基础设施
tags: [规则引擎]
lastmod: 
---

[在规则引擎中，通常会使用某种表述性的语言（而不是编程语言）来描述规则](/2012/03/20/rule_engine_1.html)。
所以规则描述语言也是规则引擎的一个重要组成部分。

目前在规则描述语言方面，并没有一个通用的标准获得规则引擎厂商的广泛支持，大部分规则描述语言都是厂商私有的。

大体来说，规则语言可以分为结构化的（Structured)和基于标记的（Markup，通常为xml）。

常见的规则描述语言包括：


- srl(Structured Rule Language)	: Fair Isaac（以前是Blaze Software）定义的结构化规则描述语言
- drl(Drools Rule Language)	: Jboss（以前是drools.org)定义的结构化规则描述语言
- RuleML(Rule Markup Language）: www.ruleml.org定义的xml规则描述语言
- SRML(Simple Rule Markup Language): xml规则描述语言
- BRML(Business Rules Markup Language):xml规则描述语言
- SWRL（A Semantic Web Rule Language):www.daml.org定义的xml规则描述语言

不管是哪种规则描述语言，都需要描述一组条件以及在此条件下执行的操作（即规则）。

下面是一个drl的例子：

```
package com.sample
 
import com.sample.DroolsTest.Message;
 
rule "Hello World"
    when
        m : Message( status == Message.HELLO, myMessage : message )
    then
        System.out.println( myMessage );
        m.setMessage( "Goodbye cruel world" );
        m.setStatus( Message.GOODBYE );
        update( m );
end

rule "GoodBye"
    when
        Message( status == Message.GOODBYE, myMessage : message )
    then
        System.out.println( myMessage );
end
```