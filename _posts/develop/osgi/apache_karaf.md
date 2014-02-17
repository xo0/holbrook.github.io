---
layout: post
title: "Apache Karaf：OSGi中间件"
description: ""
category: 软件开发
tags: [OSGi, maven]
lastmod: 
---

# 为什么需要“OSGi中间件”

尽管在OSGi Runtime(Felix, Equinox等)的基础上，OSGi组织又规定了[Blueprint规范以实现OSGi环境下的依赖注入](/2014/01/22/osgi_blueprint_container.html)，
但这还不够——没有提供类似Web开发框架那样的一些“平台级”的功能。比如日志，控制台，配置文件等。

很难想象没有Tomcat这样的Web中间件，开发Java Web应用的工作量有多大。同样的，OSGi应用也需要一种“中间件”，来实现各应用共性的一些功能，并管理应用的部署。

[Apache Karaf](http://karaf.apache.org/)就是这样的一个"OSGi中间件"。最早，Karaf只是[Apache ServiceMix](http://servicemix.apache.org/)的Kernel子项目，后来独立出来成为Apache的顶级项目。
目前，Apache Karaf已经用于Apache Geronimo, Apache ServiceMix, Fuse ESB等项目。

Apache Karaf的主要竞争对手是[Eclipse Virgo](http://www.eclipse.org/virgo/)。

# Apache Karaf的功能

![](/images/fuse/Karaf.jpg)

Apache Karaf提供了如下“开箱即用”的功能：

- 热部署

  尽管OSGi支持热部署，但并不是自动热部署，需要调用一些API去执行插拔的动作。Karaf在运行时可以自动处理`[home]/deploy`文件夹中的OSGi bundle，能够自动加载并在满足依赖关系时自动启动。

- 动态配置

  Karaf在`$KARAF_HOME/etc`文件夹中存储配置文件。这些配置内容可以在Karaf运行时动态修改。

- 日志处理

  基于Log4J的日志系统，同时支持多种日志API，如JDK 1.4, JCL, SLF4J, Avalon, Tomcat, OSGi等。

- 系统服务

  Karaf可以作为系统服务运行。

- 控制台

  可以在控制台进行服务管理、安装bundle等操作。还可以扩展自己的控制台命令。

  可以通过SSH远程访问其他服务器上的Karaf控制台。

- 多实例管理

  一个服务器上可以运行多个Karaf实例。对实例的管理可以在Karaf控制台中进行。

- Bundle仓库
  
  Karaf中内置了[Pax URL](https://ops4j1.jira.com/wiki/display/paxurl/Pax+URL)的MVN协议，可以从Maven中央仓库安装bundle。

- Bundle集合(Feature)

  类似于Eclipse的Feature，Karaf中也支持Feature，即bundle的集合。使用Feature可以简化OSGi应用的部署。



# Karaf初体验

http://karaf.apache.org/manual/latest/quick-start.html


# 

http://karaf.apache.org/manual/latest/users-guide/index.html


Installation
Directory structure
Start, stop, restart, connect
Integration in the operating system: the Service Wrapper
Console
Remote
Log
Configuration
Artifacts repositories and URLs
Provisioning and features
Deployers
KAR
Instances
Security
OBR
Enterprise
WebContainer (JSP/Servlet)
Naming (JNDI)
Transaction (JTA)
DataSource (JDBC)
MOM (JMS)
Persistence (JPA)
EJB
CDI
HA/failover and cluster
Monitoring and Management using JMX
WebConsole
Tuning