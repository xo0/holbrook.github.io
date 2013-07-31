MooseFS: 穷人的存储

[前面] ()介绍的DRBD只适合作为应用级的解决方案，不适合作为平台级的分布式文件系统。本文要介绍的MooseFS可以作为存储设备的廉价替代。

# 为什么是MooseFS

有很多的分布式文件系统，适合各种不同的应用场合。比如适合存储静态只读小文文件（网站图片）的[MogileFS](https://github.com/mogilefs),适合批量作业的[Hadoop HDFS](http://hadoop.apache.org/)，以及经过商业包装的[RedHat GFS2](https://access.redhat.com/site/documentation/zh-CN/Red_Hat_Enterprise_Linux/6/html/Global_File_System_2/)（有很多限制，比如不能超过16个节点）和[Oracle OCFS2](https://oss.oracle.com/projects/ocfs2/)（GFS的翻版，一般只用于存储oracle数据库文件）等。

适合作为通用文件系统的产品也不少, 使用较多的有MooseFS，GlusterFS和Lustre。


尽管MooseFS名气不够牛，没有加入Linux内核，而且Master节点存在单点故障隐患，但我依然选择MooseFS，是出于以下考虑：
 
- 我不需要GlusterFS那样复杂多样的文件分片机制
- MooseFS的数据冗余足够可靠
- 支持自动扩展机制，增加新的节点几乎不需要任何处理
- GlusterFS和Lustre更适合处理大文件，而我要存储大量的小文件
- 安装配置简单，官方甚至有[中文版Step-by-step指南](http://www.moosefs.org/tl_files/manpageszip/moosefs-step-by-step-tutorial-cn-v.1.1.pdf) 
- 有web界面，能够满足一般的监控需要
- 支持回收站、快照等扩展功能，尽管不是很能用得上
- Master节点的单点故障问题可以通过metalogger配合其他软件解决。

关于更多的特性对比，可以参考[这里](http://blog.csdn.net/metaxen/article/details/7108958)。

# 架构和原理

MooseFS的架构：

![moosefs_architecture](/images/2013/moosefs/moosefs_architecture.png)

MooseFS架构中包含以下4个组成部分：

- 管理服务器（master server），管理整个文件系统，存储每个文件的元数据（文件大小，文件属性，文件所在位置的这些信息），包含了所有非规则文件的全部信息，如文件夹，套接字设备，管道设备
- 数据服务器（chunk servers），用于存储文件的服务器。一个文件会在这些服务器上存储多份。
- 元数据备份服务器（ metalogger servers ）：存储元数据变化日志并周期性的下载元数据文件。在管理服务器故障时通过这些数据可以恢复出一台管理服务器。
- 客户端(clients)，访问MooseFS中存储的文件。需要支持FUSE机制的系统才能作为客户端。

向MooseFS写入文件时，文件被分成64Mb大小的块，每个块被分散的存储在块服务器的硬盘上，同时块服务器上还会存储其他块服务器上块文件的副本。同时，文件的元数据存储在Master的内存及备份服务器的文件系统中。如下图：

![moosefs_architecture](/images/2013/moosefs/moosefs_write.png)

从MooseFS读取文件时，先向master询问文件块的存储位置，然后根据这些元数据从相关的数据服务器获取数据。如下图：

![moosefs_architecture](/images/2013/moosefs/moosefs_read.png)

对于客户端来说，上述的过程是透明的，由客户端的mfsmount进程进行处理，上层应用看到的只是普通的文件操作。

# 安装配置

这个实在没什么好说的，[官方中文手册](http://www.moosefs.org/tl_files/manpageszip/moosefs-step-by-step-tutorial-cn-v.1.1.pdf) 
写得相当明白。


# 性能测试（TODO）

# 管理（TODO）

# Master高可用方案（TODO）


