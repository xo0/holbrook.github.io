


# 架构方案

![TO-BE](../images/2013/lb_lvs_solution/to-be.png)

1. LVS工作在4层，实现多链路和广域的负载均衡
2. NginX工作在7层，实现域名和虚拟目录管理、会话保持、访问控制等功能
3. 每个区域的LVS均为多节点集群
4. NginX从主备方式改为多节点集群方式，解决负载能力不足的问题

## LVS简介

LVS是上述架构中的核心组件。

[LVS(Linux Virtual Server,Linux虚拟服务器)](http://www.linuxvirtualserver.org/)，是由[章文嵩博士](http://zh.linuxvirtualserver.org/)发起的开源软件(GPL许可）。现在LVS已经是Linux内核(>2.4)的一个内置模块，同时支持FreeBSD系统。

LVS工作在4层，支持大多数的TCP和UDP协议。支持TCP协议的应用有：HTTP，HTTPS ，FTP，SMTP，POP3，IMAP4，PROXY，LDAP，SSMTP等。支持UDP协议的应用有：DNS，NTP，ICP，视频、音频流播放协议等。可以用于Web服务、Cache服务、DNS服务、FTP服务、MAIL服务、视频/音频点播服务等。

LVS具有极高的性能，可以支撑上百万的并发连接。


## 虚拟IP与负载均衡

任何负载均衡技术都要建立某种一对多的映射机制: 一个请求的入口映射到多个处理请求的节点。LVS属于IP负载均衡机制，将一个虚拟IP(Virtual IP,VIP)与后端多个真实服务器建立映射关系，客户端访问虚拟IP，LVS根据一定的调度策略和后端服务器的状态将请求转发到真实服务器(Real Server)。
根据所采用的实现技术不同，真实服务器可以将应答报文直接返回客户端或者经过LVS返回客户端。如下图：

![VIP](../images/2013/lb_lvs_solution/loadbalance.png)


LVS支持[多种IP负载均衡技术](http://thinkinside.tk/2013/06/02/lvs_lb_strategy.html)，包括VS/NAT, VS/TUN, VS/DR和VS/FULLNAT。

其中VS/TUN和VS/DR由真实服务器直接应答，所以性能较好，但是网络配置复杂，服务器有暴露的风险，运维成本较高；而VS/NAT的负载能力相对较差。

VS/FULLNAT是淘宝最新开源的LVS , 资料少

拟采用CS/NAT方式，即通过NAT技术


