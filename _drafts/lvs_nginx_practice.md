---
layout: post
title: "lvs+nginx的负载均衡测试"
description: "LVS+NginX是构建大型B/S应用的典型方式。本文记录在实验环境搭建这样一个架构，并进行功能、可靠性、性能等方面的测试的过程。"
category: 工具使用
tags: [负载均衡, cluster, lvs, nginx]

---

# 准备环境

2 LVS(cluster) + 2 NginX 
（图）

# 配置

## LVS服务器配置

1. 安装软件包

- pulse: LVS守护进程
- piranha: LVS的web管理工具，包括监控和配置

{% highlight bash %}
yum install pulse piranha
{% endhighlight %}

2. 配置LVS

配置文件位于`/etc/sysconfig/ha/lvs.cf`，使用piranha可以以图形界面的方式进行配置。

{% highlight bash %}
# 设置管理密码
piranha-passwd

# 启动piranha服务
/etc/init.d/piranha-gui start

{% endhighlight %}

接下来可以用浏览器访问: http://IP_OF_LVS:3636, 点击"Login"按钮，使用用户名`piranha`和刚才设置的密码登录，可以看到管理界面：

![1](/images/2013/lvs_nginx_practice/piranha1.png)

依次配置全局设置(GLOBAL SETTINGS), 备机设置(REDUNDANCY, 可选)，虚拟服务器(VIRTUAL SERVERS)，即可。

配置完成后，启动lvs服务(`/etc/init.d/pulse start`)，在监控界面(CONTROL/MONITORING)可以看到"Daemon"的状态为"running"。

3. 配置Real Server

这里使用nginx作为Real Server，参考[这篇文章](http://thinkinside.tk/2013/05/27/nginx_keepalived.html)进行最简单的配置，
可以看到nginx默认的欢迎界面即可。





### 配置工具

配置文件：

工具：ipvsadm(CLI)和piraha

启动服务：
启动 director 端：

# /etc/init.d/pulse start
Starting pulse:                                            [  OK  ]

pulse:  LVS的守护进程(Daemon)

### 配置系统服务

{% highlight bash %}

# 查看服务配置
/sbin/chkconfig --list

# 配置服务在启动级别 3 和 5 激活
#/sbin/chkconfig --level35 sshd on
#/sbin/chkconfig --level35 pulse on

{% endhighlight %}

### 打开IP转发功能

在`/etc/sysctl.conf`中设置`net.ipv4.ip_forward = 1`

手工开启（可以不需要重启）：

`/sbin/sysctl -w net.ipv4.ip_forward=1` 或者

`echo 1 > /proc/sys/net/ipv4/ip_forward`

查看状态：`/sbin/sysctl net.ipv4.ip_forward` 或者

`cat /proc/sys/net/ipv4/ip_forward`




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

# 维护和检查

#### 
一、关于ipvsadm:
ipvsadm是运行于用户空间、用来与ipvs交互的命令行工具，它的作用表现在：
1、定义在Director上进行dispatching的服务(service)，以及哪此服务器(server)用来提供此服务；
2、为每台同时提供某一种服务的服务器定义其权重（即概据服务器性能确定的其承担负载的能力）；
注：权重用整数来表示，有时候也可以将其设置为atomic_t；其有效表示值范围为24bit整数空间，即（2^24-1）；
因此，ipvsadm命令的主要作用表现在以下方面：
1、添加服务（通过设定其权重>0）；
2、关闭服务（通过设定其权重>0）；此应用场景中，已经连接的用户将可以继续使用此服务，直到其退出或超时；新的连接请求将被拒绝；
3、保存ipvs设置，通过使用“ipvsadm-sav > ipvsadm.sav”命令实现；
4、恢复ipvs设置，通过使用“ipvsadm-sav < ipvsadm.sav”命令实现；
5、显示ip_vs的版本号，下面的命令显示ipvs的hash表的大小为4k；
  # ipvsadm
    IP Virtual Server version 1.2.1 (size=4096)
6、显示ipvsadm的版本号
  # ipvsadm --version
   ipvsadm v1.24 2003/06/07 (compiled with popt and IPVS v1.2.0)
7、查看LVS上当前的所有连接
# ipvsadm -Lcn   
或者
#cat /proc/net/ip_vs_conn
8、查看虚拟服务和RealServer上当前的连接数、数据包数和字节数的统计值，则可以使用下面的命令实现：
# ipvsadm -l --stats
9、查看包传递速率的近似精确值，可以使用下面的命令：
# ipvsadm -l --rate


# 测试

## 功能

## 可靠性

## 性能