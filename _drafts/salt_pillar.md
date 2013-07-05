---
layout: post
title: "Pillar：定义Salt配置管理的数据"
description: "State定义了Salt配置管理的框架，Pillar则定义了Salt配置管理的数据。Pillar使得类似的配置结构可以有各自具体的、互不相同的数据，从而不需要在State中定义大量的include, extend等关系。"
category: 基础架构
tags: [devops, salt]
lastmod: 
---

# Pillar是什么？

Pillar是Salt非常重要的一个组件，它用于给特定的minion定义任何你需要的数据，这些数据可以被Salt的其他组件使用。Salt在0.9.8版本中引入了Pillar。Pillar在解析完成后，是一个嵌套的dict结构；最上层的key是minion ID，其value是该minion所拥有的Pillar数据；每一个value也都是key/value。
这里可以看出Pillar的一个特点，Pillar数据是与特定minion关联的，也就是说每一个minion都只能看到自己的数据，所以Pillar可以用来传递敏感数据（在Salt的设计中，Pillar使用独立的加密session，也是为了保证敏感数据的安全性）。

# Pillar可以用在哪些地方？
	•	敏感数据
例如ssh key，加密证书等，由于Pillar使用独立的加密session，可以确保这些敏感数据不被其他minion看到。
	•	变量
可以在Pillar中处理平台差异性，比如针对不同的操作系统设置软件包的名字，然后在State中引用。
	•	其他任何数据
可以在Pillar中添加任何需要用到的数据。比如定义用户和UID的对应关系，mnion的角色等。
	•	用在Targetting中
Pillar可以用来选择minion，使用-I选项。

# 怎样定义Pillar数据？

master配置文件中定义
默认情况下，master配置文件中的所有数据都添加到Pillar中，且对所有minion可用。如果要禁用这一默认值，可以在master配置文件中添加如下数据，重启服务后生效：
pillar_opts: False
使用SLS文件定义Pillar
Pillar使用与State相似的SLS文件。Pillar文件放在master配置文件中pillar_roots定义的目录下。示例如下：
pillar_roots:
  base:
    - /srv/pillar
这段代码定义了base环境下的Pillar文件保存在/srv/pillar/目录下。与State相似，Pillar也有top file，也使用相同的匹配方式将数据应用到minion上。示例如下：
/srv/pillar/top.sls:
base:
  '*':
    - data
    - packages
/srv/pillar/packages.sls:
{% if grains['os'] == 'RedHat' %}
apache: httpd
git: git
{% elif grains['os'] == 'Debian' %}
apache: apache2
git: git-core
{% endif %}
/srv/pillar/data/init.sls:
role: DB_master
这段代码表示，base环境中所有的minion都具有packages和data中定义的数据。Pillar采用与file server相同的文件映射方式，在本例中，packages映射到文件/srv/pillar/packages.sls，data映射到/srv/pillar/data/init.sls。注意key与value要用冒号加空格分隔，没有空格的话将解析失败。
Pillar还可以使用其他的匹配方式来选择minion，下面的例子中，servers只应用到操作系统是Debain的机器：
dev:
  'os:Debian':
    - match: grain
    - servers
# 如何知道minion拥有哪些Pillar数据？

使用执行模块pillar。pillar模块有两个funtion：pillar.data和pillar.raw。示例如下：
# salt '*' pillar.data
在master上修改Pilla文件后，需要用以下命令刷新minion上的数据：
salt '*' saltutil.refresh_pillar
如果定义好的pillar不生效，建议刷新一下试试。
Pillar中数据如何使用？
Pillar解析后是dict对象，直接使用Python语法，可以用索引（pillar['pkgs']['apache']）或get方法（pillar.get('users', {})）。详见下面的例子。

# 示例
targeting
使用-I选项表示使用Pillar来匹配minion.
salt -I 'role:DB*' test.ping
在Pillar中使用列表
Pillar的key/value结构中的value可以是string，也可以是一个list。Pillar文件定义如下：
/srv/pillar/users/init.sls：
users:
  thatch: 1000
  shouse: 1001
  utahdave: 1002
  redbeard: 1003
在top.sls中引用Pillar文件，对所有的minion应用users中的内容：
/srv/pillar/top.sls：
base:
  '*':
    - data
    - users
现在所有的minion都具有了users数据，可以在state文件中使用：
/srv/salt/users/init.sls：
{% for user, uid in pillar.get('users', {}).items() %}
{{user}}:
  user.present:
    - uid: {{uid}}
{% endfor %}
利用Pillar处理平台差异
不同的操作系统不仅管理资源的方式不同，软件包的名字、配置文件的路径也有有可能不一样。Salt的执行模块屏蔽了系统管理资源的差异。其他的差异可以根据grains中的的os、cpuarch等信息来处理，这些条件判断可以写在State文件中，但会使得State文件的逻辑不清晰。Pillar可以很好地解决这个问题。下面的例子中，在不同的os上安装对应的软件包，但state file完全一样，不需要针对os作修改，灵活方便。
/srv/pillar/pkg/init.sls：
pkgs:
  {% if grains['os_family'] == 'RedHat' %}
  apache: httpd
  vim: vim-enhanced
  {% elif grains['os_family'] == 'Debian' %}
  apache: apache2
  vim: vim
  {% elif grains['os'] == 'Arch' %}
  apache: apache
  vim: vim
  {% endif %}
/srv/pillar/top.sls：
base:
  '*':
    - data
    - users
    - pkg   
/srv/salt/apache/init.sls：
apache:
  pkg.installed:
    - name: {{ pillar['pkgs']['apache'] }}
还可以在state file中设置默认值： srv/salt/apache/init.sls：
apache:
  pkg.installed:
    - name: {{ salt['pillar.get']('pkgs:apache', 'httpd') }}


# 参考资料

- [Pillar Walkthrough](http://docs.saltstack.com/topics/tutorials/pillar.html)
- [Pillar of Salt](http://docs.saltstack.com/topics/pillar/index.html)