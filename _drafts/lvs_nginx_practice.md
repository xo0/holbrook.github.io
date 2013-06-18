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

### 配置系统服务

{% highlight bash %}

# 查看服务配置
/sbin/chkconfig --list

# 配置服务在启动级别 3 和 5 激活
/sbin/chkconfig --level35 sshd on
/sbin/chkconfig --level35 pulse on

{% endhighlight %}

### 打开IP转发功能

在`/etc/sysctl.conf`中设置`net.ipv4.ip_forward = 1`

手工开启（可以不需要重启）：`/sbin/sysctl -w net.ipv4.ip_forward=1`

查看状态：`/sbin/sysctl net.ipv4.ip_forward`




# 只在主节点配置
piranha-gui

# 可选
/sbin/chkconfig --level35 iptables on


# 为 Piranha Configuration Tool设置密码
/usr/sbin/piranha-passwd

# 启动 Piranha Configuration Tool服务
# 该服务依赖Apache HTTP Server，默认使用3636提供web配置界面
/sbin/service piranha-gui start





## NginX配置

NginX在这里当做Web服务器，不考虑其


# 测试

## 功能

## 可靠性

## 性能