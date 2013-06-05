---
layout: post
title: "LVS负载均衡方案"
description: ""
category: 解决方案
tags: [负载均衡]
---

服务器集群和负载均衡的方式目前主要有DNS轮询、CDN（内容分发网络）和IP负载均衡。
其中DNS的方式简单经济，但是可靠性很差；CDN适合静态内容为主的网站；IP负载均衡是最常用的负载均衡技术。

从实现方式上，IP负载均衡可以分为硬件负载均衡（如F5）和软件负载均衡（如LVS、NginX、HAProxy)。

信息技术中心之前实施了基于NginX的负载均衡方案，使用NginX反向代理多个应用服务器，实现应用服务器的负载均衡，
并通过NginX对域名和虚拟目录进行统一的管理。
经过半年多的使用，该方案收到了良好的效果，已经应用到外网、办公网和内网的多个应用系统。

对于外部应用系统，信息技术中心使用F5来解决链路负载均衡的问题，根据用户的网络情况选择不同ISP的链路连接到服务器。

从公司整体基础设施架构的角度来看，目前的架构还有存在一些问题和改进之处：

1. F5价格比较昂贵，而且配置相对复杂，扩展的弹性不足。
2. 现有的NginX采用主备方式实现HA，只有单个节点工作。
   在目前的虚拟机环境下每秒处理请求约2.4万，最大并发用户数为700左右。
   这样的负载能力不足以支撑互联网应用。
3. 不具备跨域负载均衡的能力，无法在总部和灾备中心之间进行负载调度。机房和灾备中心不能同时提供服务。

本方案在现有NginX的基础上，进一步使用LVS代替F5作为负载均衡器，并补充必要的其他架构组件，以其解决上述问题。




# 现状说明

下图是目前公司的外网应用架构：

![AS-IS](../images/2013/lb_lvs_solution/as-is.png)


目前公司使用F5来解决网站等高并发系统的负载均衡，对于个别的应用系统，已经实现了 F5 --> NginX --> AppServer 的访问通道。

# 架构方案


---
4. 文件同步，共享存储，内容分发，自动部署等
5. 可管理性
---


文件同步，共享存储，内容分发，自动部署等
  SQUID缓存1.登录后点击左侧按钮，将本资流分享出去；CDN

  LVS:负载均衡
  Nginx：web服务，基于内容的请求调度（通过 路径 划分 应用系统）

# 实施计划

1. 先外网，后内网
2. 先总部，后新疆
3. 逐步增加cache 服务器等

# 后续方案

1. LVS-mysql
2. LVS-mail
3. 