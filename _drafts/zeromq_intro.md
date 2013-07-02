---
layout: post
title: "ZeroMQ简介"
description: ""
category: 基础架构
tags: [ZeroMQ,消息队列]
lastmod: 
---

![ZeroMQ](/images/2013/zeromq/logo.gif)

# ZeroMQ是什么

[ZeroMQ](http://www.zeromq.org/)以嵌入式网络编程库的形式实现了一个并行开发框架（concurrency framework），
能够提供进程内(inproc)、进程间(IPC)、网络(TCP)和广播方式的消息信道，
并支持扇出(fan-out)、发布-订阅(pub-sub)、任务分发（task distribution）、请求/响应（request-reply）等通信模式。
ZeroMQ的性能足以用来构建集群产品，
其异步I/O模型能够为多核消息系统提供足够的扩展性。
ZeroMQ支持30多种语言的API，可以用于绝大多数操作系统。
在提供这些优秀特性的同时，ZeroMQ是开业的，遵循LGPLv3许可。

# Zero 之禅（The Zen of Zero）

ZeroMQ是一个很有个性的项目，其名称也暗合禅意：

- Ø 是一种权衡：让一些丹麦人恼火，但是“Ø”本身也降低了google搜索的命中率以及twitter上的关注度
- Ø 暗合“零代理(broker)”、“零延迟”
- Ø 的目标是“零管理、零消耗、零浪费”
- Ø 符合简约主义：力量的源泉是降低复杂度，而不是增加新功能

# ZeroMQ的用途（TODO)

是一种基于消息队列的多线程网络库，其对套接字类型、连接处理、帧、甚至路由的底层细节进行抽象，提供跨越多种传输协议的套接字。ZeroMQ是网络通信中新的一层，介于应用层和传输层之间（按照TCP/IP划分），其是一个可伸缩层，可并行运行，分散在分布式系统间。

ZeroMQ是一种基础架构组件，处于操作系统API和应用程序之间。
不是单独的服务或者程序，仅仅是一套组件，其封装了网络通信、消息队列、线程调度等功能，向上层提供简洁的API，应用程序通过加载库文件，调用API函数来实现高性能网络通信。

ZeroMQ不是传统的消息队列（Message Queue） —— ZeroMQ自己定位为“智能传输层”（The Intelligent Transport Layer）。

ZeroMQ原来是定位为“史上最快消息队列”，所以名字里面有“MQ”两个字母，但是后来逐渐演变发展，慢慢淡化了消息队列的身影，改称为消息内核，或者消息层了。从网络通信的角度看，它处于会话层之上，应用层之下，有了它，你甚至不需要自己写一行的socket函数调用就能完成复杂的网络通信工作。


zeromq（希望）抽象出网络编程的基本单元，然后在编写大型网络项目时，只要像堆lego积木一样，利用基本单元，方便地“组装”。
对网络编程模式的抽象，和各种经验；网络编程的关键细节：可靠性、丢包、重连等；




看看它到底是什么吧：
	.	它只是一个lib。不是什么可以用个类似于start的命令启动起来的service或者daemon程序。
	.	它是个协议。用于node之间消息的传送。这个node可以是线程、进程或者物理box。之间可以是他们任意两个之间。
	.	它不支持持久化。
	.	它的实现不包含数据的序列、反序列化。
	.	它实现了支持Pragmatic General Multicast  <http://en.wikipedia.org/wiki/Pragmatic_General_Multicast> 的广播。
	.	它高度概括并实现了三种通讯模式：Req-Rep; Pub-Sub; Pipe; 任何分布式，并行的需求，都可以用这三种模型组合起来解决问题。 <http://blog.codingnow.com/2011/02/zeromq_message_patterns.html>
	.	它不是什么MQ，它其实是个演员
ZeroMQ 并不是一个对 socket 的封装，不能用它去实现已有的网络协议。它有自己的模式，不同于更底层的点对点通讯模式。它有比 tcp 协议更高一级的协议。（当然 ZeroMQ 不一定基于 TCP 协议，它也可以用于进程间和进程内通讯。）它改变了通讯都基于一对一的连接这个假设。

# 与ActiveMQ, RabbitMQ，Thrift对比

zeromq本质上已经不是传统意义上的MQ了，它现在专注与点对点的消息传输，其他消息队列的功能对它来说太重了。

2011年，[欧洲核子研究组织（CERN）](http://zh.wikipedia.org/wiki/%E6%AD%90%E6%B4%B2%E6%A0%B8%E5%AD%90%E7%A0%94%E7%A9%B6%E7%B5%84%E7%B9%94)调查了统一用于操作CERN加速器的中间件解决方案的方式，欧洲核子研究组织的研究比较了[CORBA](http://zh.wikipedia.org/wiki/CORBA)、[Ice](http://zh.wikipedia.org/w/index.php?title=Internet_Communications_Engine&action=edit&redlink=1)，[Thrift](http://zh.wikipedia.org/w/index.php?title=Apache_Thrift&action=edit&redlink=1)，ZeroMQ, YAMI4，[RTI](http://zh.wikipedia.org/w/index.php?title=Run-Time_Infrastructure_(simulation)&action=edit&redlink=1)和 [Qpid/AMQP](http://zh.wikipedia.org/w/index.php?title=Apache_Qpid&action=edit&redlink=1)，ZeroMQ得到了最高的分数。

与其他的消息队列相比，ZeroMQ有以下一些特点
1 .点对点无中间节点。
传统的消息队列都需要一个消息服务器来存储转发消息。而ZeroMQ则放弃了这个模式，把侧重点放在了点对点的消息传输上，并且（试图）做到极致。以为消息服务器最终还是转化为服务器对其他节点的点对点消息传输上。ZeroMQ能缓存消息，但是是在发送端缓存。ZeroMQ里有水位设置的相关接口来控制缓存量。当然，ZeroMQ也支持传统的消息队列（通过zmq_device来实现）。
2 .强调消息收发模式。
在点对点的消息传输上ZeroMQ将通信的模式做了归纳，比如常见的订阅模式（一个消息发多个客户），分发模式（N个消息平均分给X个客户）等等。下面是目前支持的消息模式配对，任何一方都可以做为服务端。
		PUB and SUB
		REQ and REP
		REQ and XREP
		XREQ and REP
		XREQ and XREP
		XREQ and XREQ
		XREP and XREP
		PUSH and PULL
		PAIR and PAIR
3 .以统一接口支持多种底层通信方式（线程间通信，进程间通信，跨主机通信）。
如果你想把本机多进程的软件放到跨主机的环境里去执行，通常要将IPC接口用套接字重写一遍。非常麻烦。而有了ZeroMQ就方便多了，只要把通信协议从"ipc:///xxx"改为"tcp://*.*.*.*:****"就可以了，其他代码通通不需要改，如果这个是从配置文件里读的话，那么程序就完全不要动了，直接复制到其他机器上就可以了。以为ZeroMQ为我们做了很多。
4 .异步，强调性能。
ZeroMQ设计之初就是为了高性能的消息发送而服务的，所以其设计追求简洁高效。它发送消息是异步模式，通过单独出一个IO线程来实现，所以消息发送调用之后不要立刻释放相关资源哦，会出错的（以为还没发送完），要把资源释放函数交给ZeroMQ让ZeroMQ发完消息自己释放。

# 与Socket对比

0mq里面为何没有提供网络事件的接口，如 onConnect, onClose 那些， 网络事件的处理在业务处理中是必须的。。。
首先zeromq中，connect、close等操作并不是异步的，connect返回之后就可以知道是不是已经connect上了，不需要在onConnect回调通知。


zeromq专注于数据的传输，并尽量隐藏底层网络细节（比如自动重连功能），它并不是网络事件库（如libevent）。所以当你的程序必须要处理底层网络的细节时，你就要考虑一下是不是要用zeromq了。

最开始,考虑的问题是,zeromq和libevent,ACE这样定位的项目有什么区别没有?
1) libevent封装了对网络I/O,信号,定时器等的处理,可以基于它之上做网络层的开发.
2) ACE封装了不同平台下的系统调用,也提供好几种网络编程的模型.
然而,zeromq不是libevent,也不是ACE,因为它的主要特性是:面向消息进行通信.所以,它提供的是比libevent,ACE处在网络通信中更高一层的组件.使用它,程序员不再需要上面提到的libevent,ACE之类的库需要关心的东西,程序员如果要使用zeromq,只需要做如下的事情:
1) 告知所使用的patten,比如request-reply,pub-sub,push-pull等(下面会详细解释这个pattern).
2) 告知是用于机器之间,还是进程之间,线程之间的通信.
然后,将所需要发送的数据封装到zeromq自带的msg结构体中发送出去,使用者自己关心如何序列化/反序列化这些数据,然后如何处理这些数据就是使用者的事情了.
这样看上来,使用者要关注的事情”高”了一层,大部分的精力都可以放在业务逻辑之上了.简而言之,它让使用者的精力放在了通信模式和业务逻辑上,而不是更下面一层的网络层上.


# 参考资料

- [官方指南](http://zguide.zeromq.org/page:all)，这篇巨长的文档不仅介绍了ZeroMQ的主要方面，网络编程，还融入了ZeroMQ作者对于编程的理念，很值得精读
- [ZeroMQ社区](http://www.zeromq.org/community)，
- [ZeroMQ：云计算时代最好的通讯库](http://hi.baidu.com/ah__fu/item/bdff1d88d236f8c299255f65)
- [ZeroMQ 的模式](http://blog.codingnow.com/2011/02/zeromq_message_patterns.html)