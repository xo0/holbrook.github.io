---
layout: post
title: "lvs中的负载均衡方式"
description: ""
category: 工具使用
tags: [负载均衡, cluster, lvs]
IMAGE_ROOT:      /images/tools/lvs_lb_strategy
---



LVS支持多种负载均衡策略，包括：VS/NAT、VS/TUN和VS/DR。分别基于网络地址转换技术、IP隧道技术和直接路由技术。

	
## VS/NAT

[NAT（Network Address Translation，网络地址转换）](http://zh.wikipedia.org/wiki/%E7%BD%91%E7%BB%9C%E5%9C%B0%E5%9D%80%E8%BD%AC%E6%8D%A2)也叫做网络掩蔽或者IP掩蔽，是将IP 数据包头中的IP 地址转换为另一个IP 地址的过程。

NAT能够将私有（保留）地址转化为合法IP地址，通常用于一个公共IP地址和多个内部私有IP地址直接的映射，广泛应用于各种类型Internet接入方式和各种类型的网络中。

通过使用NAT将目的地址转换到多个服务器的方式，可以实现负载均衡，同时能够隐藏并保护内部服务器，避免来自网络外部的攻击。商用负载均衡设备如Cisco的LocalDirector、F5的Big/IP和Alteon的ACEDirector都是基于NAT方法。

VS/NAT(Virtual Server via Network Address Translation)是基于NAT技术实现负载均衡的方法。其架构如下图所示：

![VS/NAT]({{page.IMAGE_ROOT}}/vs-nat.jpg)

1. 客户通过Virtual IP Address（虚拟服务的IP地址）访问网络服务时，请求报文到达调度器
2. 调度器根据连接调度算法从一组真实服务器中选出一台服务器，将报文的目标地址Virtual IP Address改写成选定服务器的地址，报文的目标端口改写成选定服务器的相应端口，最后将修改后的报文发送给选出的服务器。
   
3. 真实的服务器处理请求，并将响应报文发到调度器。
4. 调度器将报文的源地址和源端口改为Virtual IP Address和相应的端口
5. 调度器将修改过的报文发给用户

对于LVS，需要注意：

1. 同时，调度器在连接Hash表中记录这个连接，当这个连接的下一个报文到达时，从连接Hash表中可以得到原选定服务器的地址和端口，进行同样的改写操作，并将报文传给原选定的服务器。实现了**会话保持**。
2. 我们在连接上引入一个状态机，不同的报文会使得连接处于不同的状态，不同的状态有不同的超时值。在TCP连接中，根据标准的TCP有限状态机进行状态迁移；在UDP中，我们只设置一个UDP状态。不同状态的超时值是可以设置的，在缺省情况下，SYN状态的超时为1分钟，ESTABLISHED状态的超时为15分钟，FIN状态的超时为1分钟；UDP状态的超时为5分钟。当连接终止或超时，调度器将这个连接从连接Hash表中删除。
3. 在一些网络服务中，它们将IP地址或者端口号在报文的数据中传送，若我们只对报文头的IP地址和端口号作转换，这样就会出现不一致性，服务会中断。所以，针对这些服务，需要编写相应的应用模块来转换报文数据中的IP地址或者端口号。我们所知道有这个问题的网络服务有FTP、IRC、H.323、CUSeeMe、Real Audio、Real Video、Vxtreme / Vosiac、VDOLive、VIVOActive、True Speech、RSTP、PPTP、StreamWorks、NTT AudioLink、NTT SoftwareVision、Yamaha MIDPlug、iChat Pager、Quake和Diablo。


4. 在VS/NAT的集群系统中，请求和响应的数据报文都需要通过负载调度器，当真实服务器的数目在10台和20台之间时，负载调度器将成为整个集群系统的新瓶颈。大多数Internet服务都有这样的特点：请求报文较短而响应报文往往包含大量的数据。如果能将请求和响应分开处理，即在负载调度器中只负责调度请求而响应直接返回给客户，将极大地提高整个集群系统的吞吐量。比如IP隧道技术


## VS/TUN

[IP Tunneling(IP隧道)技术](http://baike.baidu.cn/view/467497.htm)，又称为IP封装技术(IP encapsulation)，是一种在网络之间传递数据的方式。可以将一个IP报文封装到另一个IP报文（可能是不同的协议）中，并转发到另一个IP地址。IP隧道主要用于移动主机和虚拟私有网络（Virtual Private Network），在其中隧道都是静态建立的，隧道一端有一个IP地址，另一端也有唯一的IP地址。


VS/TUN（Virtual Server via IP Tunneling）是基于隧道技术实现负载均衡的方法。其架构如下图所示：

![VS/TUN]({{page.IMAGE_ROOT}}/vs-tun.jpg)

VS/TUN与VS/NAT的工作机制大体上相同，区别在于：

1. 调度器转发报文的时候进行了协议的二次封装，真实的服务器接收到请求后先进行解包。过程如下图所示：

   ![VS/TUN example]({{page.IMAGE_ROOT}}/vs-tun-flow.jpg)
   
2. 响应报文从后端服务器直接返回给客户，不需要经过调度器。


## VS/DR

[DR(Direct Routing, 直接路由)](http://baike.baidu.cn/view/3089936.htm), 路由器学习路由的方法之一。
路由器对于自己的网络接口所直连的网络之间的通信，可以自动维护路由表，而且不需要进行路由计算。

直接路由通常用在一个三层交换机连接几个VLAN的情况，只要设置直接路由VLAN之间就可以通信，不需要设置其他的路由方式。

VS/DR(Virtual Server via Direct Routing)是基于直接路由实现负载均衡的方法。其架构如下图所示：

![VS/DR]({{page.IMAGE_ROOT}}/vs-dr.jpg)


跟VS/TUN方法相同，VS/DR利用大多数Internet服务的非对称特点，负载调度器中只负责调度请求，而服务器直接将响应返回给客户，可以极大地提高整个集群系统的吞吐量。

VS/DR要求调度器和服务器组都必须在物理上有一个网卡通过不分段的局域网相连，即通过交换机或者高速的HUB相连，中间没有隔有路由器。VIP地址为调度器和服务器组共享，调度器配置的VIP地址是对外可见的，用于接收虚拟服务的请求报文；所有的服务器把VIP地址配置在各自的Non-ARP网络设备上，它对外面是不可见的，只是用于处理目标地址为VIP的网络请求。


VS/DR的整个过程与VS/TUN非常类似，不同之处在于调度器不对请求包进行二次封装，只是将目标MAC地址更改为经过调度算法选出的目标服务器的MAC地址。如下图：

![VS/TUN]({{page.IMAGE_ROOT}}/vs-dr-flow.jpg)


## 三种方法的优缺点比较 <http://zh.linuxvirtualserver.org/node/29>
          
三种IP负载均衡技术的优缺点归纳在下表中：
          
       
          VS/NAT	 VS/TUN	 VS/DR
服务器要求	   -	 支持IP隧道	 Non-arp设备
服务器网络	  - 	 LAN/WAN	 LAN
服务器数量	 少(10+)	 多(100+)  多(100+)
服务器网关   负载均衡  主动路由  主动路由


### VS/NAT

- 优点
  
  + 对后端服务器的操作系统无要求
  + 只需要一个IP地址配置在调度器上，服务器组可以用私有的IP地址。

- 缺点
  
  + 请求和响应报文都需要通过调度器，伸缩能力有限（10+)
  + 对于那些将IP地址或者端口号在报文数据中传送的网络服务，需要编写相应的应用模块来转换报文数据中的IP地址或者端口号。
    这会带来实现的工作量，同时应用模块检查报文的开销会降低系统的吞吐率。
              
### VS/TUN


              的集群系统中，负载调度器只将请求调度到不同的后端服务器，后端服务器将应答的数据直接返回给用户。这样，负载调度器就可以
              处理大量的请求，它甚至可以调度百台以上的服务器（同等规模的服务器），而它不会成为系统的瓶颈。即使负载调度器只有100
              Mbps的全双工网卡，整个系统的最大吞吐量可超过
              1Gbps。所以，VS/TUN可以极大地增加负载调度器调度的服务器数量。VS/TUN调度器可以调度上百台服务器，而它
              本身不会成为系统的瓶颈，可以用来构建高性能的超级服务器。
              VS/TUN技术对服务器有要求，即所有的服务器必须支持“IP Tunneling”或者“IP
              Encapsulation”协议。目前，VS/TUN的后端服务器主要运行Linux操作系统，我们没对其他操作系统进行
              测试。因为“IP
              Tunneling”正成为各个操作系统的标准协议，所以VS/TUN应该会适用运行其他操作系统的后端服务器。
              
### Virtual Server via Direct Routing
          <http://zh.linuxvirtualserver.org/node/32>
              跟VS/TUN方法一样，VS/DR调度器只处理客户到服务器端的连接，响应数据可以直接从独立的网络路由返回给客户。这可
              以极大地提高LVS集群系统的伸缩性。
              跟VS/TUN相比，这种方法没有IP隧道的开销，但是要求负载调度器与实际服务器都有一块网卡连在同一物理网段上，服务器
              网络设备（或者设备别名）不作ARP响应，或者能将报文重定向（Redirect）到本地的Socket端口上。
              
## 小结
本章主要讲述了可伸缩网络服务LVS框架中的三种IP负载均衡技术。在分析网络地址转换方法（VS/NAT）的缺点和网络服务的非对称性的基础上，我们给出了通过IP隧道实现虚拟服务器的方法VS/TUN，和通过直接路由实现虚拟服务器的方法VS/DR，极大地提高了系统的伸缩性。