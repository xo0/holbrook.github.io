---
layout: post
title: "用Apache Karaf作为“OSGi中间件”"
description: ""
category: 软件开发
tags: [OSGi, maven]
lastmod: 
---

# 为什么需要Apache Karaf

尽管在OSGi Runtime(Felix, Equinox等)的基础上，OSGi组织又规定了[Blueprint规范以实现OSGi环境下的依赖注入](/2014/01/22/osgi_blueprint_container.html)，
但这还不够——没有提供类似Web开发框架那样的一些“平台级”的功能。比如日志，控制台，配置文件等。

Apache Karaf弥补了OSGi框架和应用之间的这些不足，提供了一个“OSGi中间件”，能够更方便的开发和部署基于OSGi的应用。其意义类似于Tomcat对于Java Web应用的作用。

![](/images/fuse/Karaf.jpg)

Apache Karaf提供了如下“开箱即用”的功能：

- 热部署

  尽管OSGi支持热部署，但并不是自动热部署，需要调用一些API去执行插拔的动作。Karaf在运行时可以自动处理`[home]/deploy`文件夹中的OSGi bundle，能够自动加载并在满足依赖关系时自动启动。

- 动态配置

  尽管OSGi框架已经提供了`ConfigurationAdmin`服务以处理配置信息，但是使用起来不够方便。Karaf

Dynamic configuration: Services are usually configured through the ConfigurationAdmin OSGi service. Such configuration can be defined in Karaf using property files inside the [home]/etc directory. These configurations are monitored and changes on the properties files will be propagated to the services.

通过ConfigAdmin（源代码位于etc目录中）的配置

- 日志处理

Logging System: using a centralized logging back end supported by Log4J, Karaf supports a number of different APIs (JDK 1.4, JCL, SLF4J, Avalon, Tomcat, OSGi)
Provisioning: Provisioning of libraries or applications can be done through a number of different ways, by which they will be downloaded locally, installed and started.
Native OS integration: Karaf can be integrated into your own Operating System as a service so that the lifecycle will be bound to your Operating System.

包含了一个可配置的日志系统（基于Log4J，但针对众多通用的日志系统进行了包装）

- 控制台

Extensible Shell console: Karaf features a nice text console where you can manage the services, install new applications or libraries and manage their state. This shell is easily extensible by deploying new commands dynamically along with new features or applications.

- 远程访问

Remote access: use any SSH client to connect to Karaf and issue commands in the console

通过SSH实现的远程访问

- 安全框架

Security framework based on JAAS

内建的JAAS支持

- 多实例管理

Managing instances: Karaf provides simple commands for managing multiple instances. You can easily create, delete, start and stop instances of Karaf through the console.

- Bundle仓库
  
Karaf还安装了Pax URL的MVN协议，这样就可以从Maven中央仓库（在必要的情况下会自动将其包装为bundle）安装bundle了。

- Bundle集合

Karaf还提出了特性的概念，所谓特性就是bundle的集合，能以组的形式安装到运行着的OSGi运行时当中。特性包含了对obr、jetty以及spring的支持，做到了开箱即用。这样，如果需要安装多个bundle，但这些bundle之间并没有严格的运行期依赖，那么这种支持就可以大大简化这种情况。


在迁移到Apache Felix项目中前Karaf是ServiceMix Kernel，并且最终成为了Apache的顶级项目。Karaf还加入到了其他框架当中，如Eclipse Virgo和EclipseRT packages，提供了预先配置的框架与好用的OSGi bundle，这样在上手使用OSGi运行时时就会比以往更加简单。


同时Karaf作为一款成熟而且优秀的OSGi运行环境以及容器已经被诸多Apache项目作为基础容器,例如:Apache Geronimo, Apache ServiceMix, Fuse ESB,由此可见Karaf在性能,功能和稳定性上都是个不错的选择。

Karaf已经被诸多Apache项目作为基础容器,比如Apache Geronimo, Apache ServiceMix, Fuse ESB等。


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