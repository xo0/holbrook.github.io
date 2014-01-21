---
layout: post
title: "JBOSS FUSE:你必须知道的那些事"
description: ""
category: 企业架构
tags: [SOA]
lastmod: 
---

![](/images/fuse/about_fuse.png)


# JBoss Fuse：企业级ESB

我没写错，就是“企业级ESB”。尽管“ESB”是“企业服务总线“的缩写，但确实有些”所谓的ESB“并不具备企业级特性。

比如MuleCE，甚至MuleEE。

[JBoss Fuse](http://www.jboss.org/products/fuse)具备了一个企业级平台所需要的特性：

![](/images/fuse/fuse_enterprise.jpg)

除了实现基本的ESB功能外，JBoss Fuse还提供了IDE、管理和监控、集群支持等特性。这是一个产品进入企业级领域不可或缺的特性。

与Oracle Fusion、Mule ESB、Talend Unified Platform、WSO2 Platform等一样，JBoss Fuse也是一款商业的ESB产品。

JBoss Fuse由大量成熟的开源软件组合而成，包括但不仅限于：

- JBoss Fuse
  + Apache ServiceMix
    * Apache CXF
    * Apache Camel
    * Apache ActiveMQ
      - BluePrint
      - Spring
	* Karaf
  + Fuse Fabric
  + HawtIO

可以说，Fuse使用的这些开源软件是历史的选择，经过长达8年的时间，融合了最广泛使用的同类产品，最终成为一个整体的ESB平台：

![](/images/fuse/history.png)


# Apache ServiceMix

尽管JBoss Fuse官方有意无意的避免提及ServiceMix，比如这张图：

![](/images/fuse/fuse.png)

和这段文字：

    "JBoss Fuse combines core Enterprise Service Bus capabilities (based on Apache Camel, Apache CXF, Apache ActiveMQ), Apache Karaf and Fuse Fabric in a single integrated distribution."

但是[Apache ServiceMix](http://servicemix.apache.org/)确实是Fuse中最核心的组成部分，实现了ESB的核心功能。

    ”Apache ServiceMix is a flexible, open-source integration container that unifies the features and functionality of Apache ActiveMQ, Camel, CXF, ODE, Karaf into a powerful runtime platform you can use to build your own integrations solutions. It provides a complete, enterprise ready ESB exclusively powered by OSGi.“

ServiceMix是一个开源的ESB，使用Apache CXF发布服务，使用Apache Camel实现路由，使用Apache ActiveMQ实现可靠的消息传输。
ServiceMix使用OSGi将上述这些组件整合到一起，并使用Apache Karaf作为OSGi容器。

![](/images/fuse/servicemix_karaf.png)


# Apache CXF

[Apache CXF](http://cxf.apache.org/)已经成了Java发布WebService的事实标准。

CXF 继承了 Celtix 和 XFire 两大开源项目的精华，提供了对 JAX-WS 和 JAX-RS 全面的支持，并且提供了多种 Binding 、DataBinding、Transport 以及各种 Format 的支持，并且可以根据实际项目的需要，采用代码优先（Code First）或者 WSDL 优先（WSDL First）来轻松地实现 Web Services 的发布和使用。


# Apache Camel

Apache Camel基于规则路由和中介引擎实现了[企业集成模式(EIP,Enterprise Integration Patterns)](http://camel.apache.org/enterprise-integration-patterns.html)
，可以基于POJO定义路由配置和中介的规则，不需要大量的XML配置文件。

Camel基于OSGi框架并使用依赖注入。支持Blueprint或Spring DM作为OSGi的依赖注入的框架。

# Apache Aries Blueprint

有一些项目致力于将OSGi引入到企业级应用环境，比如[Apache Aries](http://aries.apache.org/)和[Eclipse Gemini](http://www.eclipse.org/gemini/)，基于OSGi架构，实现企业应用所需的事务管理(JTA)、命名服务(JNDI)、持久化标准(JPA)、
管理模型(JMX)等功能。

其中，为了解决企业级应用开发所习惯的依赖注入，这些项目都实现了OSGi R4.2中规定了Blueprint标准。
Apache Aries项目中对应的产品就是[Aries Blueprint](http://aries.apache.org/modules/blueprint.html)。

# Apache ActiveMQ

[Apache ActiveMQ](http://activemq.apache.org/)是老牌的开源MQ软件，支持JMS 1.1和2.0，支持集群和容错(Fault Tolerance)，可以实现发布/定义、点对点、分组、流等消息传递模式，提供了高可用(HA)和负载均衡机制。

本来差点被[RabbitMQ]()强了位置，但是ActiveMQ迅速支持了AMQP 1.0，估计其地位还会稳固相当一段时间。

![](/images/fuse/activemq.png)


# Apache Karaf

[Apache Karaf](http://karaf.apache.org/)是一个轻量级的OSGi容器，使用Apache Felix作为OSGi运行时，提供控制台、日志、热部署、依赖注入等功能。

![](/images/fuse/Karaf.jpg)

虽然Equinox与Felix可以单独使用，但Karaf旨在结合这两个框架出色的OSGi功能，并且保证其开箱即用。
比如说，它包含了一个可配置的日志系统（基于Log4J，但针对众多通用的日志系统进行了包装）、通过SSH实现的远程访问、通过ConfigAdmin进行配置以及内建的JAAS支持。不仅如此，Karaf还安装了Pax URL的MVN协议，这样就可以从Maven中央仓库（在必要的情况下会自动将其包装为bundle）安装bundle了。

此外，Karaf还提出了特性的概念，所谓特性就是bundle的集合，能以组的形式安装到运行着的OSGi运行时当中。特性包含了对obr、jetty以及spring的支持，做到了开箱即用。这样，如果需要安装多个bundle，但这些bundle之间并没有严格的运行期依赖，那么这种支持就可以大大简化这种情况。在迁移到Apache Felix项目中前Karaf是ServiceMix Kernel，并且最终成为了Apache的顶级项目。Karaf还加入到了其他框架当中，如Eclipse Virgo和EclipseRT packages，提供了预先配置的框架与好用的OSGi bundle，这样在上手使用OSGi运行时时就会比以往更加简单。


Karaf已经被诸多Apache项目作为基础容器,比如Apache Geronimo, Apache ServiceMix, Fuse ESB等。



# Felix和Equinox

OSGi运行时(runtime)的几个实现中，[](http://www.knopflerfish.org/)的推广度程度不高，[SpringDM已经被放弃](http://www.infoq.com/cn/news/2012/11/spring-osgi-gradle)。

[Equinox](http://www.eclipse.org/equinox/)跟随Eclipse大放光彩之后，却很难进入企业级应用领域。
而[Felix](http://felix.apache.org/)无论是从自身表现还是推广程度来看，可以说前景非常良好。

# Fuse Fabric

由于Fuse基于大量的开源项目，要实现配置管理、集群以及部署就变得非常复杂。

[Fuse Fabric](http://fuse.fusesource.org/fabric/)是一个开源的集成平台(iPaaS)，能够简化部署和变更管理等工作。

Fabirc基于Apache ZooKeeper建立了一个注册中心，利用git的分布式版本控制管理部署描述符(profiles)，对各个容器进行管理，包括
变更管理、滚动升级以及版本回退。


![](/images/fuse/fabric-diagram.png)
 
Fuse Fabric支持对Fuse ESB, Fuse MQ, Apache ActiveMQ, Camel, CXF, Karaf, ServiceMix等软件的管理。


# Apache ZooKeeper

[Apache Zookeeper](http://zookeeper.apache.org/)，是Apache Hadoop 的一个子项目，它主要是用来解决分布式应用中经常遇到的一些数据管理问题，如：统一命名服务、状态同步服务、集群管理、分布式应用配置项的管理等。通常，ZoopKeeper被用于配置文件的管理、集群管理、同步锁、Leader 选举、队列管理等。

# HawtIO


[Hawt IO](http://hawt.io/) 是一个基于HTML5的Web控制台，可以通过配置和使用[大量的插件](http://hawt.io/plugins/index.html)管理基于Java的应用或平台。Hawt IO自带的插件包括基于git的Dashboard, Wiki, 日志, 健康状态, JMX, OSGi, Apache ActiveMQ, Apache Camel, Apache OpenEJB, Apache Tomcat, Jetty, JBoss, Fuse Fabric等，也可以很容易开发自己的插件。

新版本的ActiveMQ、Fuse等都使用HawtIO作为管理控制台。

HawtIO的目标是：”为每一个JVM提供一个基于Web的控制台“。


# 标准和规范

## OSGi

[OSGi(Open Services Gateway initiative)](http://www.osgi.org/Main/HomePage是一个标准，
致力于为Java提供一个模块化的底层环境，以及一系列通用的服务(Service）。

和普通的JVM程序相比，OSGi的程序天生拥有动态模块的特点，不同的模块(OSGi里称之为Bundle)有着独立的生命周期，可以独立进行安装、启动、停止、卸载的操作，模块间的依赖性管理也由OSGi提供。

OSGi非常适合需要进行Plugin管理的项目，一个典型的成功案例就是Eclipse和它众多的Plugin。OSGi标准还规范了一系列我们常间的操作，日志、配置文件、事件队列、Web开发、JPA&JDBC等等，大部分部署OSGi标准的框架都提供了这些服务。

![](/images/fuse/osgi.png)

## JAX‐WS, JAXB, SAX

[JSR 224: JAX-WS (Java API for XML-Based Web Services)](https://jcp.org/en/jsr/detail?id=224)，一组XML web services的JAVA API规范，允许开发者选择RPC-oriented或者message-oriented 来实现自己的web services。

JAX-WS使用[JSR 222: JAXB(Java Architecture for XML Binding)](https://jcp.org/en/jsr/detail?id=222)作为绑定的规范，使用[JSR 173: SAX(Streaming API for XML)](https://jcp.org/en/jsr/detail?id=173)作为XML解析的规范。Java EE 6 引入了对 JAX-WS 的支持。


![](/images/fuse/jax-ws.gif)

## JAX‐RS 

[JSR 311: JAX-RS(The Java API for RESTful Web Services)](https://jcp.org/en/jsr/detail?id=311),定义一个统一的规范，使得 Java 程序员可以使用一套固定的接口来开发 REST 应用，避免了依赖于第三方框架。同时，JAX-RS 使用 POJO 编程模型和基于标注的配置，并集成了 JAXB，从而可以有效缩短 REST 应用的开发周期。
Java EE 6 引入了对 JAX‐RS  的支持。



## Blueprint

Blueprint提供了一个针对OSGi的依赖注入的框架，通过XML文件定义和描述各种元件组的装配。

OSGi R4.2对Blueprint进行了标准化。

目前主要有Apache Aries和Eclipse Gemini两个实现。

## EIP

[EIP(Enterprise Integration Patterns)](http://www.enterpriseintegrationpatterns.com/)，企业整合模式。

## JBI(TODO)

