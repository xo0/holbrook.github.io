---
layout: post
title: "用Apache Karaf 管理 OSGi bundles"
description: ""
category: 软件开发
tags: [OSGi, maven]
lastmod: 
---



Apache Karaf
Apache Karaf是一个轻量级的OSGi容器，使用Apache Felix作为OSGi运行时，提供控制台、日志、热部署、依赖注入等功能。



虽然Equinox与Felix可以单独使用，但Karaf旨在结合这两个框架出色的OSGi功能，并且保证其开箱即用。 比如说，它包含了一个可配置的日志系统（基于Log4J，但针对众多通用的日志系统进行了包装）、通过SSH实现的远程访问、通过ConfigAdmin进行配置以及内建的JAAS支持。不仅如此，Karaf还安装了Pax URL的MVN协议，这样就可以从Maven中央仓库（在必要的情况下会自动将其包装为bundle）安装bundle了。

此外，Karaf还提出了特性的概念，所谓特性就是bundle的集合，能以组的形式安装到运行着的OSGi运行时当中。特性包含了对obr、jetty以及spring的支持，做到了开箱即用。这样，如果需要安装多个bundle，但这些bundle之间并没有严格的运行期依赖，那么这种支持就可以大大简化这种情况。在迁移到Apache Felix项目中前Karaf是ServiceMix Kernel，并且最终成为了Apache的顶级项目。Karaf还加入到了其他框架当中，如Eclipse Virgo和EclipseRT packages，提供了预先配置的框架与好用的OSGi bundle，这样在上手使用OSGi运行时时就会比以往更加简单。

Karaf已经被诸多Apache项目作为基础容器,比如Apache Geronimo, Apache ServiceMix, Fuse ESB等。