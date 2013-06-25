---
layout: post
title: "salt的主要功能及使用"
description: ""
category: 工具使用
tags: [devops, salt, python]
lastmod: 2013-06-26
---

[Salt的介绍](/2013/06/24/salt_intro.html)中提到了Salt支持变更操作、配置管理、状态监控所需的一些功能，如下图：

![salt_functions](/images/2013/salt_usage/salt_functions.png)

本文详细介绍如何使用这些功能。

如果想对Salt的功能和使用有一个初步的了解，最好参考官方文档：[Salt Stack Walkthrough](http://salt.readthedocs.org/en/latest/topics/tutorials/walkthrough.html)。

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

{% highlight bash %}

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

- 通用的管理任务，比如apt, at, cp, cron, disk, extfs, file, grains, hosts, iptables, mount, network, pam, parted, pkg, ps, selinux, shadow, ssh, test等
- 针对特定软件的任务，比如apache, cassandra, djangomod, git, mongodb, mysql, nginx, nova, postgres, solr, sqlite3, 和tomcat

而且，自己开发Salt模块也非常简单，很容易将实际管理操作中的一些经验通过自定义的模块固化下来，并方便分享。


在开发和调试模块的时候，可以使用`test=True`参数进行模拟执行(Dry run)。比如：

    salt 'minion1.example.com' state.highstate -v test=True

# 节点信息(grains)

[grains](http://docs.saltstack.com/topics/targeting/grains.html)是Salt内置的一个非常有用的模块。在用salt进行管理客户端的时候或者写state的时候都可以引用grains的变量。

grains的基本使用举例如下：

{% highlight bash %}

 # 查看grains分类
 salt '*' grains.ls  

 # 查看grains所有信息
 salt '*' grains.items
 
 # 查看grains某个信息
 salt '*' grains.item osrelease

{% endhighlight %}

# 配置管理（state)

配置管理是Salt中非常重要的内容之一。Salt通过内置的state模块支持配置管理所需的功能。关于这部分内容，官方文档有很详细的描述，可以参考
[part 1](http://salt.readthedocs.org/en/latest/topics/tutorials/states_pt1.html)，
[part 2](http://salt.readthedocs.org/en/latest/topics/tutorials/states_pt2.html)和
[part 3](http://salt.readthedocs.org/en/latest/topics/tutorials/states_pt3.html)。

Salt中可以定义节点的目标状态，称之为state。state对应配置管理中的配置，可以对其进行标识、变更控制、变更识别、状态报告、跟踪和归档以及审计等一些的管理行为。



## 状态描述

Salt使用SLS文件（SaLt State file）描述状态。SLS使用[YAML](http://yaml.org/spec/1.1/)格式进行数据序列化，因此简单明了，可读性也很高。

### 基本描述(yaml)

下边是一个简单的SLS文件例子:

{% highlight yaml %}

 apache:
   pkg:
     - installed
   service:
     - running
     - require:
       - pkg: apache

{% endhighlight %}

该文件描述一个ID为`apache`的配置状态：

- 软件包（pkg)已经安装
- 服务应该处于运行中
- 服务的运行依赖于`apache`软件包的安装

state文件中的所有YAML变量名来自Salt的state模块。

Salt内置了大量的state模块，比如cron, cmd, file, group, host, mount, pkg, service, ssh_auth，user等。
详细清单参考[这里](http://docs.saltstack.com/ref/states/all/index.html)。

还可以开发自己的state模块。

### 扩展描述(jinja)

state可以使用[jinja](http://jinja.pocoo.org/)模板引擎进行扩展，其语法可以参考[这里](http://jinja.pocoo.org/docs/templates/)。

下面是一个更复杂的例子：

{% highlight html+jinja %}

vim:
  pkg:    
    { % if grains['os_family'] == 'RedHat' % } 
    - name: vim-enhanced    
    { % elif grains['os'] == 'Debian' % }
    - name: vim-nox    
    { % elif grains['os'] == 'Ubuntu' % }
    - name: vim-nox    
    { % endif % }
    - installed
    
{% endhighlight %}

该state增加了判断逻辑：如果是redhard系列的就安装 vim-enhanced，如果系统是Debian或者Ubuntu就安装vim-nox。

### 逻辑关系

state之间可以有[逻辑关系](http://docs.saltstack.com/ref/states/ordering.html)。常见的关系举例如下：

- require：依赖某个state，在运行此state前，先运行依赖的state，依赖可以有多个

{% highlight yaml %}
 httpd:
   pkg:
     - installed
   file.managed:
     - name: /etc/httpd/conf/httpd.conf
     - source: salt://httpd/httpd.conf
     - require:
       - pkg: httpd
{% endhighlight %}

- watch：在某个state变化时运行此模块

{% highlight yaml %}
redis:
  pkg:
    - latest
  file.managed:
    - source: salt://redis/redis.conf
    - name: /etc/redis.conf
    - require:
      - pkg: redis
    service.running:
      - enable: True
      - watch:
      - file: /etc/redis.conf
      - pkg: redis
{% endhighlight %}

watch除具备require功能外，还增了关注状态的功能


- order：优先级比require和watch低，有order指定的state比没有order指定的优先级高

{% highlight yaml %}
vim:
  pkg.installed:
    - order: 1
{% endhighlight %}

想让某个state最后一个运行，可以用last






## 顶级配置top.sls(TODO)

## 状态执行(State Enforcement)

http://docs.saltstack.com/ref/states/index.html#state-enforcement