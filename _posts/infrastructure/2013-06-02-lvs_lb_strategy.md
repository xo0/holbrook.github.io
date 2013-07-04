---
layout: post
title: "lvs的三种负载均衡机制"
description: "LVS是实现软件负载均衡的一种方式。LVS支持多种负载均衡机制，包括：VS/NAT、VS/TUN和VS/DR。分别基于网络地址转换技术、IP隧道技术和直接路由技术。VS/FULLNAT是新兴的LVS的负载均衡机制，试图解决前面三种机制各自的不足。"
category: 基础架构
tags: [负载均衡, cluster, lvs]
IMAGE_ROOT:      /images/tools/lvs_lb_strategy
lastmod: 2013-06-10
---


LVS是实现软件的[IP负载均衡](http://thinkinside.tk/2013/06/03/lb_solutions_list.html#)的一种方式。更多的负载均衡机制可以参考[这篇文章](http://thinkinside.tk/2013/06/03/lb_solutions_list.html)。

基于不同的网络技术，LVS支持多种负载均衡机制。包括：VS/NAT（基于网络地址转换技术）、VS/TUN（基于IP隧道技术）和VS/DR（基于直接路由技术）。VS/FULLNAT从本质上来说也是基于网络地址转换技术。

	
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


## 三种方法的优缺点比较



1.DR模式
DR模式是效率最高的一种，对于每个请求LVS把目的mac改成从RS中选择的机器的mac，再将修改后的数据帧在与服务器组的局域网上发送。但是局限性是LVS机器需要和RS至少能有一个网卡同在一个VLAN下面，这样限制了DR模式只能在比较单一的网络拓扑下使用。

2.TUN模式
TUN模式其实性能与DR模式相比差别不大的，TUN模式下会动态地从RS列表选择一台服务器，将请求报文封装在另一个IP报文中，再将封装后的IP报文转发给选出的服务器；RS服务器收到报文后，先将报文解封获得原来目标地址为VIP的报文，服务器发现VIP地址被配置在本地的IP隧道设备上，所以就处理这个请求，然后根据路由表将响应报文直接返回给客户。TUN模式可以解决DR模式下不能垮网段的问题，甚至可以垮公网进行。但是需要RS能支持ipip模块。

3.NAT模式
NAT模式对RS没有其他要求，唯一的要求是得把RS的网关设置为LVS机器。因为进出的流量都要通过LVS机器，所以性能相对会差很多，而且部署的规模很难做大。

以上DR模式和TUN模式在部署的时候都需要在本机绑定VIP，非常麻烦，比如我们之前有的老应用因为一些历史问题单个应用的VIP有40来个，如果用LVS做负载均衡基本就崩溃了，每次新增/删除一个VIP，估计得线下测试好多次ip addr add/del的用法。NAT模式在部署的时候也是太麻烦了。而且还有一个很关键很关键的是，使用了LVS后万一被人ddos怎么办？syn-cookie在抵挡攻击的时候效果一般不是太好，这样攻击透过lvs直击后端应用就杯具了。所以在很多大公司都不敢直接把lvs放公网，前面得加个防火墙啥的。所以淘宝单独搞了一个fullnat模式，一方面可以解决部署绑VIP、或者把RS的网关设置为LVS机器IP带来的部署复杂问题，另外一方面是加了一个syn-proxy等等，可以抵挡下一般的网络层攻击。但是使用FULLNAT模式后确实有个麻烦的是后端机器看不到用户的IP了，所以RS上还得用装上打过补丁的内核，对取IP的操作就劫持才能获取到用户IP。

对于大规模网站，其实无聊单独使用哪种LVS都是不能替换商业设备的，所以还是得配合nginx or haproxy做负载均衡。这个时候最简单的就是lvs(fullnat)+nginx/haproxy（nginx官方版本现在没有4层代理功能，haproxy对后端又不支持keepalive）,当然使用DR模式或者TUN模式也还可以的。总之基本都得用2层才能搞得定，满足大部分应用上的需求。其实对于很多小公司，我觉得直接用nginx/haproxy就OK了。搞的那么复杂维护成本会非常高的，自动化运维没有跟上的时候只会把自己给玩死。


          
三种IP负载均衡技术的优缺点归纳在下表中：
          
<table class="tabletable-condensed">
<tr><th></th><th>VS/NAT</th><th>VS/TUN</th><th>VS/DR</th><th></tr>
<tr><td>服务器要求</td><td>-</td><td>支持IP隧道</td><td>Non-arp设备</td></tr>
<tr><td>服务器网络</td><td>-</td><td>LAN/WAN</td><td>LAN</td></tr>
<tr><td>服务器数量</td><td>少(10+)</td><td>多(100</td><td>+)多(100+)</td></tr>
<tr><td>服务器网关</td><td>负载均衡</td><td>主动路由</td><td>主动路由</td></tr>
</table>


### VS/NAT

- 优点
  
  + 对后端服务器的操作系统无要求
  + 只需要一个IP地址配置在调度器上，服务器组可以用私有的IP地址。

- 缺点
  
  + 请求和响应报文都需要通过调度器，伸缩能力有限（10+)
  + 在调度器和服务器之间要配置策略路由
  + 对于那些将IP地址或者端口号在报文数据中传送的网络服务，需要编写相应的应用模块来转换报文数据中的IP地址或者端口号。
    这会带来实现的工作量，同时应用模块检查报文的开销会降低系统的吞吐率。
              
### VS/TUN

- 优点
  
  + 不需要调度应答报文，性能高
  
- 缺点
  
  + 所有的服务器必须支持“IP Tunneling”协议，要安装内核模块（比如IPIP等），配置复杂
  + 有建立IP隧道的开销
  + 服务器上直接绑定虚拟IP(Virtaul IP)，风险很大

### VS/DR

- 优点

  + 与VS/TUN相比，没有IP隧道的开销，性能最好

- 缺点
  + 要求负载调度器与实际服务器都有一块网卡连在同一物理网段（同一个VLAN）上
  + 要求服务器网络设备（或者设备别名）不作ARP响应，或者能将报文重定向（Redirect）到本地的Socket端口上
  + 服务器上直接绑定虚拟IP(Virtaul IP)，风险很大

              
## VS/FULLNAT

如上节所述，前面三种传统的负载均衡机制各自存在一些不足。


[VS/FULLNAT](http://kb.linuxvirtualserver.org/wiki/IPVS_FULLNAT_and_SYNPROXY)是为了解决这些不足而新开发的一种转发模式。
VS/FULLNAT的特点是：

1. 调度器和服务器可以跨VLAN通信，不需要配置在同一个网段
2. 请求和应答报文都经过调度器，服务器不需要绑定虚拟IP

VS/FULLNAT这两个特点可以简化网络拓扑，降低运维成本和风险。


