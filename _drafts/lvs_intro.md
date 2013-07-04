# LVS是什么

[LVS](http://www.linuxvirtualserver.org/), Linux Virtual Server, Linux虚拟服务器。

LVS可以作为负载均衡集群的前端调度器，从而实现高性能和高可用性。

LVS工作在4层，支持TCP和UDP协议，可以广泛用于web、cache、mail、ftp、media、VoIP等服务的负载均衡。

LVS是[章文嵩博士](http://zh.linuxvirtualserver.org)在1998年发起的开源项目，目前已经集成到Linux内核中。

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


# LVS的应用场景

由于LVS工作在4层，所有工作在TCP/IP之上的应用或服务都可以通过LVS建立负载均衡集群以提高并发能力。下面列出LVS的典型应用场景。

## Web负载均衡

## IP管理
与Nginx的域名和虚拟目录管理类似

网站最前端的指向应该是LVS，也就是DNS的指向应为lvs均衡器，lvs的优点令它非常适合做这个任务。重要的ip地址，最好交由lvs托管，比如数据库的ip、webservice服务器的ip等等，这些ip地址随着时间推移，使用面会越来越大，如果更换ip则故障会接踵而至。所以将这些重要ip交给lvs托管是最为稳妥的。

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


3、  《Red_Hat_Enterprise_Linux-5-Virtual_Server_Administration-zh-CN》