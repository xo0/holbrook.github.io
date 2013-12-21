---
layout: post
title: "CEP中的时间推理(Temporal)"
description: "时间推理(Temporal)是CEP中特有的条件判断(LHS)。本文介绍13种时间推理运算符及其DRL表示"
category: 基础设施
tags: [CEP]
lastmod: 
---

[CEP](/2012/11/06/about_cep.html)中的[事件(Event)](/2013/12/21/event_in_CEP.html)具有两个与时间相关的属性。一个是timestamp，标记事件发生的时间；另一个是duration，标记事件持续的时间间隔。

由这两个时间属性，还可以计算出事件结束的事件。

时间推理(Temporal)是CEP中特有的条件判断([LHS](/2012/12/06/rule_language.html#menuIndex3))，其判断的要素正是基于事件的上述时间属性。

Allen在《An Interval-based Representation of Temporal Knowledge》中描述了13种时间推理的运算符。

下面用DRL语言介绍这13种运算符。其中，运算符的参数格式均为`[#d][#h][#m][#s][#[ms]]`。比如`3m30s`、`4m`等。


# After 和 Before

  ![](/images/rule-engine/temporal-after_and_before.png)

  ```
  // x∈[a,b]时，满足以下条件
  $eventA : EventA( this before[a,b] $eventB )
  $eventB : EventB( this after[a,b] $eventA )

  ```  

  + 如果没有给出参数，则a=1ms, b=+∞
  + 如果只给出一个参数a,则b=+∞
  

# Coincides

  ![](/images/rule-engine/temporal-coincides.png)

  ```
  // x∈[0,a]，且y∈[0,b]时，满足以下条件
  $eventA : EventA( this coincides[a,b] $eventB )
  $eventB : EventB( this coincides[a,b] $eventA )

  ```  

  + 如果只给出一个参数a,则b=a
  + 如果不给出参数，则a=0,b=0


# During 和 Includes

  ![](/images/rule-engine/temporal-during.png)

  ```
  // x∈[a,b]，且y∈[c,d]时，满足以下条件
  $eventA : EventA( this during[a,b,c,d] $eventB )
  $eventB : EventB( this includes[a,b,c,d] $eventA )
  
  ```  

  + 如果只给出二个参数a,b,则c=a,d=b
  + 如果只给出一个参数b,则a=0,c=0,d=b
  + 如果不给出参数，则a=0,b=+∞, c=0,d=+∞


# Finishes 和 Finished by


  ![](/images/rule-engine/temporal-finishes.png)

  ```
  // x∈[0,a]时，满足以下条件
  $eventA : EventA( this finishes[a] $eventB )
  $eventB : EventB( this finishedby[a] $eventA )

  ```  

  + 如果不给出参数，则a=0



# Meets 和 Met by

  ![](/images/rule-engine/temporal-after_and_before.png)

  ```
  // x∈[0,a]时，满足以下条件
  $eventA : EventA( this meets[a] $eventB )
  $eventB : EventB( this metby[a] $eventA )

  ```  

  + 如果没有给出参数，则a=0


# Overlaps 和 Overlappd by

  ![](/images/rule-engine/temporal-overlaps.png)

  ```
  // x∈[a,b]时，满足以下条件
  $eventA : EventA( this overlaps[a,b] $eventB )
  $eventB : EventB( this overlappedby[a,b] $eventA )

  ```  

  + 如果只给出一个参数b,则a=0
  + 如果不给出参数，则a=0,b=0



# Starts 和 Started by


  ![](/images/rule-engine/temporal-starts.png)

  ```
  // x∈[0,a]时，满足以下条件
  $eventA : EventA( this starts[a] $eventB )
  $eventB : EventB( this startedby[a] $eventA )

  ```  

  + 如果不给出参数，则a=+∞


