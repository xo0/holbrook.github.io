---
layout: post
title: "salt的主要功能"
description: ""
category: 工具使用
tags: [devops, salt, python]
lastmod: 2013-06-25
---

[Salt的介绍](/2013/06/24/salt_intro.html)中提到了Salt支持变更操作、配置管理、状态监控所需的一些功能，如下图：

![salt_functions](/images/2013/salt_usage/salt_functions.png)

本文详细介绍如何使用这些功能。

# 批量操作(targeting)

再回顾一下[前文中的例子](http://thinkinside.tk/2013/06/24/salt_intro.html#测试-ref):

{% highlight bash %}

 # 测试连通性
 salt '*' test.ping

 # 查询主机运行了多长时间
 sudo salt '*' cmd.run "uptime"


 # 批量重启服务
 salt '*' cmd.run "service httpd restart"

 # 让多台机器一起，使用Apache Bench进行压力测试
 salt '*' cmd.run "ab -n 10 -c 2 http://www.google.com/"


{% endhighlight %}

上面的例子都是对多个节点进行批量操作：使用通配符"'*'"对所有注册的节点进行操作。Salt支持多种方式对节点id(minion id)进行匹配。包括：

- 默认：[通配符(globbing)](http://en.wikipedia.org/wiki/Glob_(programming))
- E：[正则表达式(Regular Expression)](http://zh.wikipedia.org/zh-hans/%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8F)
- L：列表
- N: 分组(group)
- C：复合匹配

先看一下通配符、正则表达式和列表的例子：

{% highlight bash %}

 # 通配符是最常用的匹配方式。Salt使用[linux风格的通配符](http://docs.python.org/2/library/fnmatch.html)
 salt '*' test.ping
 salt '*.example.net' test.ping
 salt '*.example.*' test.ping
 salt 'web?.example.net' test.ping
 salt 'web[1-5]' test.ping
 salt 'web-[x-z]' test.ping
 
 # 正则表达式可以适应更复杂的情况。使用[python的re模块](http://docs.python.org/2/library/re.html#module-re)进行匹配
 salt -E 'web1-(prod|devel)' test.ping
 
 # 最直接的方式是自己指定多个minion，即列表
 salt -L 'web1,web2,web3' test.ping

{% endhighlight %}

[复合匹配(Compound matchers)](http://docs.saltstack.com/topics/targeting/compound.html)有点复杂，后续会在其他文章中专门介绍。

分组匹配见本文的下一节。


# 节点分组（nodegroups）

好吧，批量操作确实很爽。但是每次都输入匹配规则有点麻烦，对于复杂的匹配规则更是如此。
salt的 [nodegroups功能]((http://docs.saltstack.com/topics/targeting/nodegroups.html)可以将常用的匹配规则保存下来（称之为minion的分组）。批量操作是，只需要使用L标记指定要操作的group名字即可。
groups定义在master的配置文件`/etc/salt/master`中。

group 的定义可以使用各种匹配规则，比如：

{% highlight %}

group1: 'L@foo.domain.com, bar.domain.com,baz.domain.com or bl*.domain.com'
group2: 'G@os:Debian and foo.domain.com'

{% endhighlight %}


同样的，使用复合匹配(Compound matchers)定义group的内容不在本文范围之内。


# 命令编排（execution）

Salt生来就有命令编排的功能。据说，Salt最先实现的是远程执行技术，然后才添加的配置管理功能。Salt使用ZeroMQ来处理命令执行的请求和响应消息，安装配置简单，并且性能非常高。

Salt即可以批量执行命令，也可以单机执行。通常单机执行用于测试：

- 单机（立即）执行。 使用[salt-call](http://docs.saltstack.com/topics/tutorials/quickstart.html)命令单机执行操作
- 批量(立即)执行。最常用的操作。使用salt命令，对匹配的minion节点执行操作


Salt可以执行的命令也可以分为两种：

- 系统命令，使用`cmd.run`执行
- Salt模块，将常用的命令/批处理封装到内置的Salt模块(module)，使用`模块名.功能名`的方式执行。

比如：

{% highlight bash %}

 # 执行系统命令
 salt '*' cmd.run 'hostname'
 
 # 执行Salt模块
 salt '*' disk.usage

{% endhighlight %}


使用Salt模块的好处是能够做到一致。比如同样是查看磁盘使用情况，`salt '*' cmd.run "df -h"`只能用于*NIX节点，而`salt '*' disk.usage`对*NIX和Windows都适用，并且采用相同结构返回数据，便于批量处理。

Salt已经内置了[大量的模块](http://docs.saltstack.com/ref/modules/all/index.html)，这些模块涵盖了日常管理任务的主要任务，包括：

- 通用的管理任务，比如apt, at, cp, cron, disk, extfs, file, hosts, iptables, mount, network, pam, parted, pkg, ps, selinux, shadow, ssh, test等
- 针对特定软件的任务，比如apache, cassandra, djangomod, git, mongodb, mysql, nginx, nova, postgres, solr, sqlite3, 和tomcat

而且，自己开发Salt模块也非常简单，很容易将实际管理操作中的一些经验通过自定义的模块固化下来，并方便分享。

在开发和调试模块的时候，可以使用`test=True`参数进行模拟执行(Dry run)。比如：

    salt 'minion1.example.com' state.highstate -v test=True


# 配置管理（TODO)

