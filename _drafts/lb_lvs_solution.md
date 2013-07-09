LVS负载均衡方案

摘要：

IP负载均衡是与DNS轮询、CDN(内容分发网络)并列的一种负载均衡集群技术。
对IP负载均衡的实现既有硬件设备（如F5）又有软件方式（如LVS、NginX、HAProxy)。

信息技术中心现有的基础设施架构中，使用F5和NginX分别实现链路负载均衡和web负载均衡。

LVS是另一种IP负载均衡软件。与NginX相比，LVS的并发能力可以提高2个数量级；与F5相比，LVS能够以很低的成本达到相同数量级的并发能力，并且具备更高的可定制性。

本方案试图结合LVS与NginX，构建一种高并发、低成本、可定制、易维护的负载均衡集群架构，以期替代F5并提供更好的特性。

LVS具备广泛的适用性，除Web负载均衡外，还可用于很多场景。本方案中列举一些常用的场景，作为今后其他架构设计时的参考。

目录：



# 现状分析

信息技术中心之前实施了基于NginX的负载均衡方案，使用NginX反向代理多个应用服务器，实现应用服务器的负载均衡，
并通过NginX对域名和虚拟目录进行统一的管理。
经过半年多的使用，该方案收到了良好的效果，已经应用到外网、办公网和内网的多个应用系统。

对于外网系统，信息技术中心使用F5来解决链路负载均衡的问题，根据用户的网络情况选择不同ISP的链路连接到服务器。
如下图：

![AS-IS](../images/2013/lb_lvs_solution/as-is.png)

1. F5 负责Web服务器的负载均衡，支持多链路负载均衡
2. NginX 负责应用服务器负载均衡，支持域名、虚拟目录的重定向
3. 如果同时需要多链路负载均衡和虚拟目录重定向功能，需要F5与Nginx级联
4. F5 为双节点集群方式，NginX为双节点主备方式 

从公司整体基础设施架构的角度来看，目前的架构还有存在一些问题和改进之处：

1. F5价格比较昂贵，而且配置相对复杂，扩展的弹性不足。
2. 现有的NginX采用主备方式实现HA，只有单个节点工作。
   在目前的虚拟机环境下每秒处理请求约2.4万，最大并发用户数为700左右。
   这样的负载能力不足以支撑互联网应用。
3. 不具备广域域负载均衡的能力，无法在总部和灾备中心之间进行负载调度。机房和灾备中心不能同时提供服务。
4. 不同的应用系统采用不同的架构方案，带来复杂性。



# F5、NginX、LVS的分析和对比

## F5的特性

F5的全称是F5 BIG-IP，[F5 Networks公司](http://www.f5.com/)研发的著名的硬件负载均衡设备。并发能力可以达到400万--800万（取决于不同的型号）。F5的主要功能包括：

1. 多链路的负载均衡和冗余
   
   可以接入多条ISP链路，在链路之间实现负载均衡和高可用。

2. 防火墙负载均衡

   F5具有异构防火墙的负载均衡与故障自动排除能力。

3. 服务器负载均衡

   这是F5最主要的功能，F5可以配置针对所有的对外提供服务的服务器配置Virtual Server实现负载均衡、健康检查、回话保持等。

4. 高可用

   F5设备自身的冗余设计能够保证99.999%的正常运行时间，双机F5的故障切换时间为毫秒级。

   使用F5可以配置整个集群的链路冗余和服务器冗余，提高可靠的健康检查机制，以保证高可用。

5. 安全性

   与防火墙类似，F5采用缺省拒绝策略，可以为任何站点增加额外的安全保护，防御普通网络攻击，包括DDoS、IP欺骗、SYN攻击、teartop和land攻击、ICMP攻击等。

6. 易于管理

   F5提供HTTPS、SSH、Telnet、SNMP等多种管理方式，包含详尽的实时报告和历史纪录报告。同时还提供二次开发包(i-Control)。

7. 其他

   F5还提供了SSL加速、软件升级、IP地址过滤、带宽控制等辅助功能。

目前，公司内部主要使用上述1、3、4功能实现应用系统的多链路负载均衡，以提高其并发能力和高可用性。

## NginX的特性
## LVS的特性
## LVS与F5、NginX的对比

[LVS(Linux Virtual Server, Linux虚拟服务器)](http://www.linuxvirtualserver.org/)是一种软件的负载均衡器。

LVS工作在4层，支持大多数的TCP和UDP协议。支持TCP协议的应用有：HTTP，HTTPS ，FTP，SMTP，POP3，IMAP4，PROXY，LDAP，SSMTP等。支持UDP协议的应用有：DNS，NTP，ICP，视频、音频流播放协议等。可以用于Web服务、Cache服务、DNS服务、FTP服务、MAIL服务、视频/音频点播服务等。

LVS是章文嵩博士在1998年发起的开源项目，遵循GPL许可。现在LVS已经集成到Linux内核中(>2.4)，并且支持FreeBSD系统。

LVS具有极高的性能，可以支撑上百万的并发连接。

LVS实现了基于IP技术的负载均衡，提供3种负载均衡机制：

VS/NAT（基于网络地址转换技术）
VS/TUN（基于IP隧道技术）
VS/DR（基于直接路由技术）
三种机制的详细说明参考这里。

在三种机制的基础上，LVS还提供了多种负载调度（Scheduling）策略。包括：

rr（Round Robin）, 平均分配负载
wrr（Weighted Round Robin），在rr的基础上增加权重设置
lc（Least-Connections），分配给连接数最少的服务器
wlc（Weighted Least-Connections），在lc的基础上增加权重设置
lblc（Locality-Based Least Connections），在lc的基础上将相同目标IP地址的请求调度到同一台服务器。通常用于缓冲（Cache）集群，可以提高各缓存服务器的访问局部性和Cache命中率
lblcr（Locality-Based Least Connections with Replication），与lblc类似，只不过同一个目标IP地址会映射到一组缓存服务器
dh（Destination Hashing），根据目标地址的Hash运算结果进行分配，通常用于链路负载均衡
sh（Source Hashing），根据请求客户端地址的Hash运算结果进行分配，可以实现某种程度的会话保持（Session Persistence)
sed（Shortest Expected Delay），在wlc的基础上，进一步计算出期望延迟，向(1+已有连接数)/权重最小者分配请求
nq（Never Queue），无队列调度。直接分配给当前无连接的服务器

# LVS技术验证和测试


# 架构方案

区分不同的负载要求。（条件）

![TO-BE](../images/2013/lb_lvs_solution/to-be.png)

1. LVS工作在4层，实现多链路和广域的负载均衡
2. NginX工作在7层，实现域名和虚拟目录管理、会话保持、访问控制等功能
3. 每个区域的LVS均为多节点集群
4. NginX从主备方式改为多节点集群方式，解决负载能力不足的问题

## LVS简介

LVS是上述架构中的核心组件。

[LVS(Linux Virtual Server,Linux虚拟服务器)](http://www.linuxvirtualserver.org/)，是由[章文嵩博士](http://zh.linuxvirtualserver.org/)发起的开源软件(GPL许可）。现在LVS已经是Linux内核(>2.4)的一个内置模块，同时支持FreeBSD系统。

LVS工作在4层，支持大多数的TCP和UDP协议。支持TCP协议的应用有：HTTP，HTTPS ，FTP，SMTP，POP3，IMAP4，PROXY，LDAP，SSMTP等。支持UDP协议的应用有：DNS，NTP，ICP，视频、音频流播放协议等。可以用于Web服务、Cache服务、DNS服务、FTP服务、MAIL服务、视频/音频点播服务等。

LVS具有极高的性能，经实际测试每秒处理xxx,最大并发xxx并发


## 虚拟IP与负载均衡

任何负载均衡技术都要建立某种一对多的映射机制: 一个请求的入口映射到多个处理请求的节点。LVS属于IP负载均衡机制，将一个虚拟IP(Virtual IP,VIP)与后端多个真实服务器建立映射关系，客户端访问虚拟IP，LVS根据一定的调度策略和后端服务器的状态将请求转发到真实服务器(Real Server)。
根据所采用的实现技术不同，真实服务器可以将应答报文直接返回客户端或者经过LVS返回客户端。如下图：

![VIP](../images/2013/lb_lvs_solution/loadbalance.png)


LVS支持[多种IP负载均衡技术](http://thinkinside.tk/2013/06/02/lvs_lb_strategy.html)，包括VS/NAT, VS/TUN, VS/DR和VS/FULLNAT。

其中VS/TUN和VS/DR由真实服务器直接应答，所以性能较好，但是网络配置复杂，服务器有暴露的风险，运维成本较高；而VS/NAT的负载能力相对较差。

VS/FULLNAT是淘宝最新开源的LVS , 资料少

拟采用CS/NAT方式，即通过NAT技术



TODO:图和说明

## 调度算法的选择(?)



## 健康检查
  LVS支持4-7层健康检查
  LVS之间有心跳检测（keepalived?)

## 会话保持

TODO:图， 红框，通道。原理（同一IP/mac地址，LVS的策略，NginX的策略）

## 安全

## 部署结构

防火墙之后，网段/子网，真实服务器等，参考》RHEL文档

## 广域、多链路负载均衡

LVS的DR模式，支持通过广域网进行负载均衡。这个其他任何负载均衡软件目前都不具备。

简单的 :DNS轮询不能保证可靠性
中等的： GeoDNS:  求推荐靠谱的GeoDNS服务商:dnspod实在是有点慢
	http://dyn.com/
	GeoDNS是根据用户地理位置解析到不同的IP上
	推荐 dyn.com 我在用twitter.com 也在dyn的服务，不过他们的服务级别比我用的要高，当然价格也贵。。
  智能DNS：
  自建DNS服务器：

复杂的，需要网络运营商的配合，才能能在真正的BGP路由中插入VIP地址。一般来说运营商很少作这样的设置。
需要LVS使用VS/DR模式？？？

过于复杂

## LVS集群

## LVS方式

## 管理和维护

## 性能测试

实验环境：LVS-->NginX(2)

---
4. 文件同步，共享存储，内容分发，自动部署等
5. 可管理性
---


文件同步，共享存储，内容分发，自动部署等
  SQUID缓存1.登录后点击左侧按钮，将本资流分享出去；CDN


# 实施计划

1. 先外网，后内网
2. 先总部，后新疆
3. 逐步增加cache 服务器等



