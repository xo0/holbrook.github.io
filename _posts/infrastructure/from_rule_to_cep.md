---
layout: post
title: "从规则引擎到复杂事件处理(CEP)"
description: ""
category: 基础设施
tags: [规则引擎, CEP]
lastmod: 
---

从规则引擎到CEP很简单，

从实现角度来看，Drools Fusion即使规则引擎，又可以作为CEP


	Session Clock
	stream
	滑动窗口
	事件的内存管理





# 会话时钟

由于事件的时间性，处理事件时需要一个参考时钟。
这个参考时钟在会话配置(KnowledgeSessionConfiguration)中指定，所以称为会话时钟(Session Clock)。

有很多种场景需要对时钟进行控制，比如：

- 规则测试

  测试总是需要一个可控的环境,并且当测试包含了带有时间约束的 规则时,不仅需要控制输入规则和事实,而且也需要时间流。

- 定期(regular)执行

  通常,在运行生产规则时,应用程序需要一个实时时 钟,允许引擎对时间的行进立即作出反应。

- 特殊环境

  特殊环境可以对时间的控制有特殊的要求。群集环境可能需要在心 跳中的时钟同步,或 JEE 环境可能需要使用一个应用服务器提供的时钟,等 等。
- 规则重演或模拟

  要重演场景或模拟场景也需要应用程序控制时间流。

Drools中默认使用基于系统时钟的实时时钟(realtime)，也可以使用能被应用程序控制的伪时钟(pseudo)。设置伪时钟的方法如下：

{% highlight java %}
KnowledgeSessionConfiguration conf = KnowledgeBaseFactory.newKnowledgeSessionConfiguration();
conf.setOption( ClockTypeOption.get( "pseudo" ) );

StatefulKnowledgeSession session =kbase.newStatefulKnowledgeSession( conf, null );

SessionPseudoClock clock = session.getSessionClock();

// then, while inserting facts, advance the clock as necessary:
FactHandle handle1 = session.insert( tick1 );
clock.advanceTime( 10, TimeUnit.SECONDS );
FactHandle handle2 = session.insert( tick2 );
clock.advanceTime( 30, TimeUnit.SECONDS );
FactHandle handle3 = session.insert( tick3 );

{% endhighlight %}






# 流模式

对于如何提交事实(Fact)，规则引擎没有特别的要求，因为Fact是时间无关的。此时，规则引擎工作在云(Cloud)模式下。这也是规则引擎默认的工作模式。

但是，在处理实时/准实时事件(Event)时，时间成为推理过程的一个重要的变量。此时，规则引擎工作在流(Stream)模式。

## 云(Cloud)模式

Drools运行在云模式时，没有时间流的概念，引擎知道所有的事实(Fact)和事件(Event)。
尽管事件具有时间戳，但由于引擎没有“现在”的概念，所以该时间戳仅仅是一个属性，不代表顺序。

在此模式中，引擎将所有的事实/事件看做是一个无序的云。引擎也无法管理事件的生命周期。


## 流(Stream)模式

对于CEP，需要使引擎工作在流模式下。


此时要求每个流事件按照时间顺序插入。

## 流(stream)支持


流共有一组共同的特性:
在流中的事件通过时间戳被排序。对不同的流时间戳有不同的语义,但是它们 总是内在地被排序。
事件的数量(volumes)总是很高的。 原子事件自己是很少有用的。通常根据多个事件之间的相关性或流或其他来源
提取含义。
流可以是相似的,即包含单一类型的事件;或者是异类的,即包含多种类型的 事件。

Drools 归纳流概念作为一个“入口点”进入到引擎内。入口点是 Drools 的一个 大门,事实从它进来。事实可以是正规事实或者象事件这样的特殊事实。
在 Drools 中,来自一个入口点(流)的事实可以与来自其他的入口点的事实联 合,或者事件与来自工作内存的事实联合。尽管这样,它们决不能混淆,即它们 不能丢失对它们进入到引擎的那个入口点的引用。这是非常重要的,因为它可能 包含有通过几个入口点进入引擎内的相同类型的事实,例如,一个通过入口点 A 插入到引擎的事实决不会匹配来自入口点 B 的模式。

声明和使用入口点

在 Drools 中,通过在规则中直接使用入口点来显式地声明它们。即,在一个规 则中引用一个入口点,会使引擎在编译时识别且创建适当的结构来支持那个入口 点。
那么,例如,我们假设一个银行业应用程序,来自流的事件被送入到该系统中。 一个流包含了所有在 ATM 机上执行的事务。所以,如果一条规则说:当且仅当 存款余额超过了请求的取款金额,取款才被授权,规则应该象下面这样:
例子 2.8 流用法的例子
rule "authorize withdraw"
when
WithdrawRequest( $ai : accountId, $am : amount ) from entry-point "ATM Stream"
    CheckingAccount( accountId == $ai, balance > $am )
then
    // authorize withdraw
end
在上面的例子中,引擎编译器会识别联结到入口点"ATM Stream"的模式,并且 会创建规则库需要的所有结构用于支持"ATM Stream",而且只会匹配来自"ATM Stream"的 WithdrawRequests。在上面的例子中,规则也把来自流的事件与来 自主工作内存的一个事实(CheckingAccount)联合在一起。
现在,我们假设第二个规则,它规定被安排在银行分行的取款请求,会增加 2 元的费用。
例子 2.9 使用了一个不同的流。
rule "apply fee on withdraws on branches"
when
    WithdrawRequest( $ai : accountId, processed == true ) from
entry-point "Branch Stream"
    CheckingAccount( accountId == $ai )

    then
    // apply a $2 fee on the account
end
上面的规则会匹配与第一个规则有完全相同类型的事件(WithdrawRequest), 但是它来自不同的流,所以,被插入到"ATM Stream"中的事件决不会根据第二 个规则中的模式进行运算,因为该规则规定它只对来自"Branch Stream"的模式 感兴趣。
所以,入口点,除了是流的一个适当抽象外,也是在工作内存中扩大事实的一种 方法,同是也是减少交叉产品爆炸(cross products explosions)的一个宝贵工 具。不过,这是其他时间讨论的一个主题。
插入事件到一个入口点内是同样简单的。而不是直接把事件插入到工作内存,如 下所示把它们插入到入口点:
例子 2.10 插事实到一个入口点内
// create your rulebase and your session as usual
StatefulKnowledgeSession session = ...
// get a reference to the entry point
WorkingMemoryEntryPoint atmStream =
session.getWorkingMemoryEntryPoint( "ATM Stream" );
// and start inserting your facts into the entry point
atmStream.insert( aWithdrawRequest );
上面的例子,显示了如何手动地把事实插入到一个特定的入口点内。虽然,通常 应用程序会使用众多适匹器中的一个,用于插接一个流终点(to plug a stream end point),如一个 JMS 队列,直接进入到引擎入口点内,不必编码手动插入。 Drools 管道 API,有几个适匹器和助手用于做这个,以及有关如何做它的例子。

## 流(Stream)模式

# 滑动窗口

# 事件的内存管理

