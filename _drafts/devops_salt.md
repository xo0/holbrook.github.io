---
layout: post
title: "用salt管理成千上万的服务器"
description: "实在是厌倦了对大量服务器的管理，尤其进入了虚拟化时代，每个系统的每个组件可能都有大量的实例在运行。
当我发现Salt的时候，我的眼前一亮：这正是我所需要的东西。Salt可以。。。"
date: 2013-06-22
category: 工具使用
tags: [devops, 敏捷, salt, python]
lastmod: 2013-06-22
---

# 简介

加入到证券公司的IT部门，尽管所在的部门挂了一个“研发部”的名字，但是我发现有大概40%的时间是在做运维工作。

作为一名“非专职运维人员”，实在是厌倦了不断重复的查看系统状态，检查应用，修改配置，补丁发布以及部署开发、测试、生产环境等等大量重复性的工作。

一度使用一些自己开发的脚本来辅助工作，但是效果不是很明显，很多脚本来自“灵机一动”或“冲冠一怒”，没有一个统一的规划和设计。

直到我发现了[Salt](),我的眼前一亮：这正是我所需要的东西。

尽管在此之前，我接触过[Puppet]()和[Fabric]()，听说过[Chef]()和[CFEngine]()，但是这些工具并没有让我心动。

如果非要说Salt有什么独特之处打动了我，那就是：

- 简单：可能是源于python的简约精神，Salt的安装配置和使用简单到了令人发指的地步。任何稍有经验的linux使用者可以在10分钟之内搭建一个测试环境并跑通一个例子（相比之下，puppet可能需要30--60分钟）。
- 高性能：Salt使用大名鼎鼎的ZeroMQ作为通讯协议，性能极高。可以在数秒钟之内完成数据的传递
- 可伸缩：基于消息来实现.所以能够提供横强的拓展性；Salt可以通过级联的方式方便扩展，足以管理分布在广域网的上万台服务器。

尽管现在[豆瓣](http://www.douban.com/)、[]()等著名网站的运维团队都在使用puppet，但是我相信，他们切换到salt只是一个时间问题。毕竟傀儡(puppet)不是必不可少的，但是谁又能离开盐(salt)呢？

# Salt的功能

加入到证券公司的IT部门，尽管所在的部门挂了一个“研发部”的名字，但是我发现有大概40%的时间是在做运维工作。

作为一名“非专职运维人员”，实在是厌倦了不断重复的查看系统状态，检查应用，修改配置，补丁发布以及部署开发、测试、生产环境等等大量重复性的工作。

配置管理，命令编排

而Salt恰好满足了我的需要。


我的工作：
1. 应用开发(AppDev)，
2. 发布、部署和配置(DevOps), 
3. 系统管理(SysAdmin).

Func 适合做 1 和 3
RunDeck 适合做 2
puppet


master,管理端
minion,被管理端

# 安装配置

## 管理端

1. 安装           

yum install salt-master      

2. 配置

文件: /etc/salt/master           
配置文件选项介绍:  http://docs.saltstack.com/ref/configuration/master.html           
最基本字段:                
	interface: 服务端监听IP
	      3:运行           调试模式:                salt-master  -l debug           后台运行:                salt-master  -d             作为centos管理员,我选择:                /etc/init.d/salt-master start      4:注意事项:           1:监听端口                 4505(publish_port):salt的消息发布系统                 4506(ret_port):salt客户端与服务端通信的端口            所以确保客户端能跟服务端的这2个端口通信

## 被管理端

### linux
1:安装           yum install salt-minion      2:配置文件           /etc/salt/minion           配置文件选项介绍: http://docs.saltstack.com/ref/configuration/minion.html           最基本字段:                master: 服务端主机名                id: 客户端主机名(在服务端看到的客户端的名字)      3:运行           调试模式:                salt-minion  -l debug           后台运行:                salt-minion  -d             作为centos管理员,我选择:                /etc/init.d/salt-minion start      4:注意事项:           1：minion 默认和主机名salt的主机通信           2:关于配置文件               salt的配置文件均为yaml风格               $key: $value     #注意冒号后有一个空格 

### windows

http://wiki.saltstack.cn/installation/windows

### mac os x
http://wiki.saltstack.cn/installation/osx

## 测试

sudo salt '*' test.ping

sudo salt '*' cmd.run "uname -r"
  144  sudo salt '*' grains.item osrelease
  145  sudo salt '*' test.ping
  146  sudo salt '*' cmd.run "ls"
  147  sudo salt '*' cmd.run "dir"

  
# Salt的网络资源

## 网站

- [salt官方网站](http://saltstack.org/)，
- [中国SaltStack用户组(CSSUG)网站](http://saltstack.cn/)
- [Into The Salt Mine,关于Salt的各种安装、配置、使用的博客](http://intothesaltmine.org/blog/html/index.html)

## 代码

- [saltstack将代码托管在github上](https://github.com/saltstack),包括：
  + [salt主工程](https://github.com/saltstack/salt)
  + [salt-bootstrap，一个快速安装Salt的脚本](https://github.com/saltstack/salt-bootstrap)
  + [salt states参考配置](https://github.com/saltstack/salt-states)，大量用于监控目标主机状态的配置文件，可以直接使用
  + [Salt Cloud](https://github.com/saltstack/salt-cloud),使得Salt支持各种云服务(Amazon EC2, HP Cloud, OpenStack,Parallels等)的扩展
  + [salty-vagrant](https://github.com/saltstack/salty-vagrant), 用Salt管理[Vagrant虚拟环境](http://www.vagrantup.com/)的扩展
  + [salt-api](https://github.com/saltstack/salt-api)，基于Salt进行二次开发的包
  + [salt-ui](https://github.com/saltstack/salt-ui), 一个图形界面
  + [pepper](https://github.com/saltstack/pepper),  Stand-alone CLI tools that mimic Salt's CLI tools but proxy Salt commands through salt-api 
  + [ salt-contrib](https://github.com/saltstack/salt-contrib), Salt Module Contributions 
  + [ sublime-text](https://github.com/saltstack/sublime-text), Salt-related syntax highlighting and snippets for Sublime Text 
  + [ formulae](https://github.com/saltstack/formulae), 
  + [ salt-vim](https://github.com/saltstack/salt-vim), Vim files for editing Salt files 
  + [ salt-ci](https://github.com/saltstack/salt-ci), Salt-CI — Salt Continuous Integration 
  + [ salt-genesis](https://github.com/saltstack/salt-genesis),
  + [ salt-qa](https://github.com/saltstack/salt-qa),
  + [ saltstack_org](https://github.com/saltstack/saltstack_org),
  + [ salt-windows-install](https://github.com/saltstack/salt-windows-install),


- [中国SaltStack用户组在github上托管的代码](https://github.com/cssug)，包括：
  + [salt的一个分支](https://github.com/cssug/salt), 其目标是实现中心库和配置管理功能。
  + [salt的web管理界面](https://github.com/cssug/salt-dashboard)，基于Django。

