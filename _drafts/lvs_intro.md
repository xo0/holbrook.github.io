# LVS简介

[LVS(Linux Virtual Server, Linux虚拟服务器)](http://www.linuxvirtualserver.org/), 实现了负载均衡集群的前端调度器（Director）。

LVS工作在4层，支持大多数的TCP和UDP协议。支持TCP协议的应用有：HTTP，HTTPS ，FTP，SMTP，POP3，IMAP4，PROXY，LDAP，SSMTP等。支持UDP协议的应用有：DNS，NTP，ICP，视频、音频流播放协议等。可以用于Web服务、Cache服务、DNS服务、FTP服务、MAIL服务、视频/音频点播服务等。

LVS是[章文嵩博士](http://zh.linuxvirtualserver.org)在1998年发起的开源项目，遵循GPL许可。现在LVS已经集成到Linux内核中(>2.4)，并且支持FreeBSD系统。

LVS具有极高的性能，可以支撑上百万的并发连接。


# LVS的特性

LVS实现了基于IP技术的负载均衡，提供3种负载均衡机制：

- VS/NAT（基于网络地址转换技术）
- VS/TUN（基于IP隧道技术）
- VS/DR（基于直接路由技术）

三种机制的详细说明参考[这里](/2013/06/02/lvs_lb_strategy.html)。

在三种机制的基础上，LVS还提供了多种负载调度（Scheduling）策略。包括：

- rr（Round Robin）, 平均分配负载
- wrr（Weighted Round Robin），在rr的基础上增加权重设置
- lc（Least-Connections），分配给连接数最少的服务器
- wlc（Weighted Least-Connections），在lc的基础上增加权重设置
- lblc（Locality-Based Least Connections），在lc的基础上将相同目标IP地址的请求调度到同一台服务器。通常用于缓冲（Cache）集群，可以提高各缓存服务器的访问局部性和Cache命中率
- lblcr（Locality-Based Least Connections with Replication），与lblc类似，只不过同一个目标IP地址会映射到一组缓存服务器
- dh（Destination Hashing），根据目标地址的Hash运算结果进行分配，通常用于链路负载均衡
- sh（Source Hashing），根据请求客户端地址的Hash运算结果进行分配，可以实现某种程度的会话保持（Session Persistence)
- sed（Shortest Expected Delay），在wlc的基础上，进一步计算出期望延迟，向`(1+已有连接数)/权重`最小者分配请求
- nq（Never Queue），无队列调度。直接分配给当前无连接的服务器

# LVS与F5的对比

  LVS最直接的竞争对手应该是F5 BIG-IP。F5可以支持400万--800万并发连接，支持一些方便配置和管理的功能，价格在几十万人民币左右;
  而LVS完全免费，可以支持100万--400万并发连接，一些特性的配置和图形化监控等功能需要自己解决。

# LVS的应用场景

由于LVS工作在4层，所有工作在TCP/IP之上的应用或服务都可以通过LVS建立负载均衡集群以提高并发能力。按照集群的用途，可以列出LVS的典型应用场景：

- web缓存及反向代理
  web缓存及反向代理位于web服务器之前，可以缓存静态内容，只把动态内容的请求反向代理到后端的web服务器。常见的web缓存服务器如Squid，NginX都可以使用LVS构建集群系统。

- web服务器/应用服务器
  LVS可以作为web服务器/应用服务器（如Nginx,Apache,Tomcat等）的前端调度器，支持会话保持功能。

- 数据库服务器
  典型的mysql主-从集群中，LVS可以作为多个从服务器的负载调度器。

- 重要IP的管理
  对于重要的IP地址（如ESB、数据库、中间件等），可以交给LVS进行统一管理，避免更换IP带来的麻烦。
  

# LVS与NginX的对比

Web负载均衡的实现产品很多，除了F5这种硬件负载均衡器之外，还有很多开源的软件产品。常见的如LVS,NginX,HAProxy等。

NginX是使用比较广泛Web负载均衡器。NginX工作在7层，

LVS与NginX

3～5万条并发连接


# Web负载均衡：LVS与NginX的对比

三、Nginx对网络的依赖较小，理论上只要ping得通，网页访问正常，nginx就能连得通，nginx同时还能区分内外网，如果是同时拥有内外网的节点，就相当于单机拥有了备份线路；lvs就比较依赖于网络环境，目前来看服务器在同一网段内并且lvs使用direct方式分流，效果较能得到保证。


七、LVS的优势非常多：①抗负载能力强；②工作稳定(因为有成熟的HA方案)；③无流量；④基本上能支持所有的应用，基于以上的优点，LVS拥有不少的粉丝；但世事无绝对，LVS对网络的依赖性太大了，在网络环境相对复杂的应用场景中，我不得不放弃它而选用Nginx。

八、Nginx对网络的依赖性小，而且它的正则强大而灵活，强悍的特点吸引了不少人，而且配置也是相当的方便和简约，小中型项目实施中我基本是考虑它的；当然，如果资金充足，F5是不二的选择。


Q11: 基于Layer 4 的负载均衡与基于Layer 7 的负载均衡有什么区别？
A：基于Layer 4 的负载均衡在截取数据流以后，对数据包要检查与分析的部份仅仅限于IP 报
头及TCP/UDP 报头，而不关心TCP 或UDP 包内部信息。而基于Layer7 的负载均衡，则要
求负载均衡器除了支持Layer4 负载均衡以外，还要理解数据包中4 层以上的信息，也即应用
层的信息。例如，可以理解分析http 协议，从数据包中提取出http uri 或cookie 信息。基于
Layer4 与基于Layer7 负载均衡或交换对数据包检查的深度不一样，基于Layer4 的交换偏重
的是网络层，而Layer7 偏重的是应用层，与应用结合很紧密。负载均衡器在作这两种方式的
负载均衡时的性能也不一样。
Q12: 为什么需要基于Layer7 的负载均衡？
A：简单来说，之所以需要基于Layer7 的负载均衡，有以下原因：
 会话保持(Persistence)的需要：在很多应用中，单靠Layer4 层的信息，也即IP 地址
与端口的信息，是不足以分辨出会话的相关性。这样要实现会话保持，就必须依靠
于Layer7 交换。
 应用安全的需要：要做到应用级的安全，负载均衡器必须能检查、分析应用层的信
息，并以此作为流量分发、访问控制的依据。
 服务器、应用健康检查的需求：如前面所述，负载均衡器还有一个重要任务就是要及
时发现服务器上的异常情况，这种异常情况不仅仅限于网络故障，还包括服务或应
用能不能对访问请求作出正确的响应。这也是要通过对数据包的应用层进行分析才
能实现。


# 参考资料

- [LVS官方网站](http://www.linuxvirtualserver.org/)
- [LVS中文社区](http://zh.linuxvirtualserver.org/)
- [LVS手册：可伸缩网络服务的设计与实现](http://zh.linuxvirtualserver.org/node/7)
- man ipvsadm
- 《Red_Hat_Enterprise_Linux-5-Virtual_Server_Administration-zh-CN》