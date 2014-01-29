---
layout: post
title: "Apache Camel的核心概念"
description: ""
category: 企业架构
tags: [SOA, ESB]
lastmod: 
---

# Apache Camel的整体架构

[Apache Camel](http://camel.apache.org/)是一个基于规则路由和中介引擎。

Camel能够用来处理来自于不同源的事件和信息，定义规则进行消息的传递和转换等处理，以实现基于消息的应用整合。

Camel的整体架构如下图所示：

![](/images/camel/camel-architecture.png)


# Endpoint

端点，接收或发送消息的通道。Endpoint通过[URI](http://zh.wikipedia.org/wiki/%E7%BB%9F%E4%B8%80%E8%B5%84%E6%BA%90%E6%A0%87%E5%BF%97%E7%AC%A6)连接消息源或目标。
为了适应各种不同的URI协议，如http,ftp,JMS,smtp等，Camel中提供了多种Endpoint，也支持扩展自己的Endpoint。

![](/images/camle/endpoints.png)


# Component



## Processor


# 实现规则


提供企业集成模式的Java对象(POJO)的实现，通过应用程序接口（或称为陈述式的Java领域特定语言（DSL））来配置路由和中介的规则。领域特定语言意味着Apache Camel支持你在的集成开发工具中使用平常的，类型安全的，可自动补全的Java代码来编写路由规则，而不需要大量的XML配置文件。同时，也支持在Spring中使用XML配置定义路由和中介规则。

## 代码方式

## XML配置方式

# FUSE Mediation Router: 企业级Camel

 FuseSource提供Camel的经测试、认证并提供支持的企业级版本，称作FUSE Mediation Router

 http://fusesource.com/products/enterprise-camel/