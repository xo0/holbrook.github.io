---
layout: post
title: "lvs+nginx的负载均衡测试"
description: "LVS+NginX是构建大型B/S应用的典型方式。本文记录在实验环境搭建这样一个架构，并进行功能、可靠性、性能等方面的测试的过程。"
category: 工具使用
tags: [负载均衡, cluster, lvs, nginx]

---

# 准备环境

2 LVS(cluster) + 2 NginX 


# 配置
## LVS 配置

### 初始 LVS 配置

{% highlight bash %}

# 查看服务配置
/sbin/chkconfig --list

# 配置服务自启动
/sbin/chkconfig --level35 sshd on
/sbin/chkconfig --level35 sshd on

{% endhighlight %}


1. 配置服务
   服务配置工具：chkconfig、ncurses-based 程序 ntsysv 和图形界面程序 Services Configuration Tool。

   需要自启动的服务：

   - piranha-gui 服务(只用于主节点)
   - pulse 服务
   - sshd 服务

最好是将这些服务设置为在运行级别 3 和运行级别 5 都激活。要达到此目的,请使用 chkconfig,并 为每个服务输入以下命令:
/sbin/chkconfig --level 35 daemon on
在上面的命令中,请使用您想要激活的服务名称替换 daemon。要获得系统中的服务及在什么运行级别 将其设定为激活的列表,请使用以下命令:


## NginX配置

NginX在这里当做Web服务器，不考虑其


# 测试

## 功能

## 可靠性

## 性能