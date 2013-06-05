宏源证券ESB实施方案


# 概述
## 目的
   ESB是SOA的核心组件，在技术层面解决SOA的整合问题。

   由于业界对于ESB并没有标准的定义和一致的规范，所以对于ESB产品应该提供哪些功能、在SOA中ESB应该承担哪些职能也没有明确的方法论指导。在本方案中，将明确宏源证券ESB的边界和范围。

   SOA是企业架构（EA）范畴的事情，需要各个应用系统协同和支持。ESB作为。。。。需要有一些标准和规范进行约束，本文。。。。

   升级规划
   
** 现状分析

目前公司已经部署了Mule ESB社区版（CE）

已经部署了ESB，但还存在问题
没有充分发挥ESB的功能
一些误用的情况

选用Mule
详细说明，问题说明

性能测试的结果

** ESB的作用
事实上，ESB在SOA中扮演着重要的角色，在技术层解决了SOA的整合问题，耦合了应用与应用之间的集成逻辑，使得SOA更灵活，更易于扩展，更敏捷。有了ESB，新建的服务消费者应用程序不需要关心服务的提供者在哪里，使用何种通讯协议，与其交互的数据是怎样的……，它只需向ESB发出请求，使用开放的、标准的通讯协议。相反，若某个可重用的价值较大的服务位于某一个遗留系统中，而由于种种原因，该遗留系统不能在短期内重写，此时ESB可以架起该服务与其使用者之间沟通的桥梁。当然，ESB的作用远不止这些，业内也有很多讨论，本文不再赘述。读者可在Google上搜索ESB Patterns获得相关资料。
然而，ESB并非“救世主”，它注定也不可能解决应用系统整合中出现的所有问题。道理很简单，计算机发展历史长从没有出现过一个产品/工具可以满足所有的应用需求，技术发展得很快，需求发展更快，所以技术永远跟不上需求。此外，ESB或ESB产品有其特定的适用范围，它是基础设施层的概念/产品，解决的是整合中的常见问题，比如服务连通、路由、消息丰富、服务的注册/查找/发布等服务的管理、服务监控和质量保证等。ESB不能解决的问题比其能解决的问题多很多。比如，让它去做人工流程的编排是不合适的，让它提供门户类产品那样的用户交互也是极其困难的……。
笔者支持过许多客户项目。在这些项目中，有的客户将ESB用的好，有的则勉强用上，用的功能很简单，有的则用ESB做一些原本不属于它该做的工作。在这里，笔者仅从个人的立场，分享自己这些年来积累的ESB实施经验。下面列出笔者常看到但不推荐的实施和笔者在实施ESB的过程中积累的一些较好的实践方式，供读者参考。同时欢迎批评指正。

* 需求分析
ESB可以做什么
  ESB的主要功能之一是连接异构协议和数据
我们需要用ESB来做什么
ESB
未来：云，流程中心，CEP，。。。。


为了更好的支持SOA，希望ESB能够提供以下支持


* ESB实施方案
** 是否需要UDDI——Galaxy

** ESB与消息中间件
感觉倾向不同，可以讨论一下
消息中间件倾向于可靠的消息传输
ESB依靠开放的接口，试图集成各种传输格式，消息中间件的格式也是其集成范围之一
** 网络区域与ESB分区

** 对未来企业架构的适应
*** ESB与规则引擎
*** ESB与流程中心
BPEL是为了编排连接各个服务的，BPEL不是为了工作流审核审批的。根本就是两个目的两码事，不要混淆。用BPEL实现工作流，或者用工作流想实现BPEL，都是错误思路。
ESB是运行服务，并且驱动BPEL的。
*** ESB与CEP


** 规范和流程
*** 服务发布和注册流程
*** 服务使用流程
*** 开发规范
*** 消息协议
*** 通信协议


** 产品选型
*** 关于Mule 
*** Galaxy
*** ActiveMQ

** 整体架构

* 结论

