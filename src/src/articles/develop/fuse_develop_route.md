---
layout: post
title: "开发和部署JBoss FUSE中的路由(Route)"
date: 2012-04-14
update: 2012-04-14
description: ""
category: 软件开发
tags: [SOA, OSGi, Maven, FUSE]
---

快速开始
========

因为*Fuse的核心组成部分是ServiceMix*，而ServiceMix的核心组成部分是Apache
Camel，所以“用Fuse开发路由”也就是“开发Camel路由”。

[Camel提供了大量的开发](http://search.maven.org/#search%7Cga%7C1%7Corg.apache.camel.archetypes)工具
，其中[camel-archetype-blueprint](http://search.maven.org/#search%7Cga%7C1%7Ca%3A%22camel-archetype-blueprint%22)
是一个[maven
archetype](http://maven.apache.org/guides/introduction/introduction-to-archetypes.html)，
可以基于*Blueprint*，以依赖注入的方式配置CamelContext。下面快速创建一个demo:

``` {.bash}
    mvn archetype:generate  \
    -DarchetypeGroupId=org.apache.camel.archetypes \
    -DarchetypeArtifactId=camel-archetype-blueprint \
    -DarchetypeVersion=2.12.2 \
    -DgroupId=thinkinside.demo.fuse \
    -DartifactId=route-demo \
    -Dversion=1.0.0-SNAPSHOT
```

会创建如下结构的一个工程：

![](./assets/images/fuse/route-demo-structure.png)

从 `pom.xml`
来看，这是一个*使用maven-bundle-plugin构建的OSGibundle工程*。

基于*Blueprint*装配Camel
========================

Context

工程的\`META-INF/blueprint/blueprint.xml'文件是一个Blueprint配置文件：

``` {.xml}
      <?xml version="1.0" encoding="UTF-8"?>
      <blueprint xmlns="http://www.osgi.org/xmlns/blueprint/v1.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xmlns:camel="http://camel.apache.org/schema/blueprint"
             xsi:schemaLocation="
             http://www.osgi.org/xmlns/blueprint/v1.0.0 http://www.osgi.org/xmlns/blueprint/v1.0.0/blueprint.xsd
             http://camel.apache.org/schema/blueprint http://camel.apache.org/schema/blueprint/camel-blueprint.xsd">

        <bean id="helloBean" class="thinkinside.demo.fuse.HelloBean">
            <property name="say" value="Hi from Camel"/>
        </bean>

        <camelContext id="blueprintContext" trace="false" xmlns="http://camel.apache.org/schema/blueprint">
          <route id="timerToLog">
            <from uri="timer:foo?period=5000"/>
            <setBody>
                <method ref="helloBean" method="hello"/>
            </setBody>
            <log message="The message contains ${body}"/>
            <to uri="mock:result"/>
          </route>
        </camelContext>

      </blueprint>
```

该配置文件中，定义了一个id为 `blueprintContext` 的Camel
Context。这个Context中定义了一个路由：

1.  入口为一个Timer类型的Endpoint
2.  使用预定义的bean为Message设置body
3.  记录日志
4.  出口为一个Mock类型的Endpoint

如果使用FuseIDE，可以看到图形化的配置界面：

![](./assets/images/fuse/route-design.png)
部署到ServiceMix
================

执行 `mvn package` 后，得到 `route-demo-1.0.0-SNAPSHOT.jar`
，这是一个OSGi bundle。可以将jar文件部署到

=\$SERVICEMIX~HOME~/deploy/=
目录中。正常情况下，bundle的依赖关系被满足，该bundle会被自动启动。

从ServiceMix到Fuse
==================

上述的过程也适用于JBoss Fuse。

但是Fuse对ServiceMix进行了再次封装，需要使用Fuse对应的版本。比如，=camel-archetype-blueprint=
的版本可能要使用 `2.10.0.redhat-60024`
这样的“Fuse版本号”，否则在部署到Fuse是可能会发生版本不匹配的问题。

Fuse提供了一个maven仓库，专门提供这种定制版本的组件，需要在maven中配置：

``` {.xml}
        <repository>
            <id>fusesource</id>
            <url>http://repo.fusesource.com/nexus/content/groups/public/</url>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
            <releases>
                 <enabled>true</enabled>
             </releases>
        </repository>
```
