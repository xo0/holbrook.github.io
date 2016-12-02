---
layout: post
title: "DRBD:基于软件的存储解决方案"
date: 2013-07-17
description: "DRBD在服务器之间对块设备（如硬盘，分区，逻辑卷等）进行复制。一个虚拟的DRBD设备同时映射到本地和远端的块设备。从用户的角度来说，DRBD设备与其他块设备没有任何不同，可以在其上创建文件系统，进行文件操作。"
category: 基础设施
tags: [HA, keepalived, 负载均衡, cluster]
---

# DRBD简介

[DRBD（Distributed Replicated Block Device，分布式复制块设备）](http://www.drbd.org/ )，是一种基于软件的存储解决方案：

DRBD在服务器之间对块设备（如硬盘，分区，逻辑卷等）进行复制。一个虚拟的DRBD设备同时映射到本地和远端的块设备。从用户的角度来说，DRBD设备与其他块设备没有任何不同，可以在其上创建文件系统，进行文件操作。

![drbd_architecture](images/2013/drbd/drbd_architecture.png)

当用户对DRBD设备上的文件系统进行写操作时，该操作先缓存到buffer cache，DRBD作为buffer cache和磁盘调度器（DISK SCHED）之间的一层，在进行磁盘操作的同时通过网络将操作发送到另一台服务器上的DRBD。


两台服务器上的DRBD分别将操作发送给各自的磁盘调度器，使得写操作完全同步，从而实现了块设备的镜像。


从达到的效果来看，DRBD实现了基于网络的RAID-1。与文件共享技术（如NFS、SAMBA）相比，DRBD无需共享，数据完全复制，相当于实时同步的冗余备份，可以提高可用性；而且DRBD工作在系统内核空间而不是用户空间，具有很高的性能，能够满足实时性要求。


无论是功能还是性能，DRBD都足以在高可用集群（HA Cluster）中替代共享盘阵。


# 安装配置

## 准备块设备

首先要在每个服务器节点上准备好块设备，如分区、逻辑卷等。需要注意的是，为了避免“死锁”问题，DRBD不建议使用loop设备。

## 安装drbd

对于RHEL/CentOS，配置了[EL库](http://elrepo.org)就可以从包管理器安装DRBD了：

{% highlight bash %}
rpm -Uvh http://elrepo.org/elrepo-release-6-5.el6.elrepo.noarch.rpm
yum update
yum search drbd
yum -y install kmod-drbd84 drbd84-utils
reboot
 # 检查内核模块
lsmod | grep -i drbd
modprobe -l | grep -i drbd

{% endhighlight %}

会安装`/sbin/drbdadm`, `/sbin/drbdmeta`, `/sbin/drbdsetup`, `/usr/sbin/drbd-overview`等命令行工具以及`/etc/drbd.conf`, `/etc/drbd.d/*`配置文件和 `/etc/init.d/drbd` 启动脚本。

## 修改配置

其实`/etc/drbd.conf`不重要，只是include了`drbd.d/global_common.conf`和`drbd.d/*.res`。`drbd.d/global_common.conf`是全局配置，先不去管它，就用默认值，我们要做的是增加一个.res资源文件，比如`drbd.d/r0.res`:

{% highlight c %}

resource r0 {
  on server1 {
    device    /dev/drbd1;
    disk      /dev/VolGroup00/drbd-disk0;
    address   192.168.1.11:7789;
    meta-disk internal;
  }

  on server2 {
    device    /dev/drbd1;
    disk      /dev/VolGroup/drbd-disk0;
    address   192.168.1.12:7789;
    meta-disk internal;
  }
}

{% endhighlight %}


配置很简单，就是指定在两台服务器（可以是多台）上将要创建的DRBD设备文件、使用的块设备、通信的IP地址和端口等。需要注意的是server1和server2必须与各自的主机名一致。

## 创建DRBD设备

两句话：`drbdadm create-md r0`和`drbdadm up r0`, 在每个服务器上都执行一次。

在选定的主服务器上执行：

`drbdadm primary --force r0`

马上查看`/proc/drbd`内容，会发现正在执行同步。

# 使用

现在，可以开始使用DRBD块设备了。在选定的主服务器上可以挂载（mount) `/dev/drbd1`，对其进行的文件操作都会同步到备份节点上的块设备。

# 双主方式（TODO）

上面的配置是最基本的配置方式，即主从方式。使用这种方式，所有的读写操作只能在主服务器上进行，并且从节点设备也不能挂载，在需要操作从节点上的设备时必须先将从节点“升级”为主节点。所以实用价值并不高。

DRBD还支持双主模式，两个节点都作为primary节点，同时可以写入，配合集群文件系统OCFS2，能够实现文件的互相备份。





