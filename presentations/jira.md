% Atlassian Jira
% 问题跟踪系统
% <br/><br/>王海阔 @hysec.com, 2014


# 项目中的“问题”

## issues不是problems

![](images/jira/project-issues.jpg)

- 任何需要开展行动的事情
- Jira汉化版中翻译为“事件”

<div class="notes">
有影响，需要处理的事情
缺陷，新需求，改进，新特性，任务和子任务，其他任何事情
常见的有以下几种（Jira中内置的）
</div>

## bugs

![](images/jira/bug.jpg)

<div class="notes">
bug(缺陷)：软件中存在的导致软件产品在某种程度上不能满足用户的需要的错误。产生原因：
1）设计不合理;
2）功能未实现；
3）与需求不一致;
5）用户不能接受的其他问题，如存取时间过长、界面不美观;
6）甚至，软件实现了需求未提到的功能。

一般分成几个级别：致命的(Fatal)，严重的(Critical)，一般的(Major)，微小的(Minor),建议(Enhancemental)
</div>

## New Requirement

![](images/jira/Requirements.jpeg)

<div class="notes">
项目之痛
新需求，需求变更
软件为了达到目标所要具备的条件或能力。（多种定义）
</div>

## Improvement

![](images/jira/Improvement.jpeg)

<div class="notes">
对已实现的特性的改善或提高
我们真的很努力
</div>

## New Feature

![](images/jira/ideas.jpg)

<div class="notes">
新提出的、尚未实现的特性
</div>

## Task and Sub-Task

![](images/jira/daily_tasks.jpg)

<div class="notes">
项目的进度和任务可以在jira中管理
<div>

## ANYTHING else...

![](images/jira/issues1.jpg)

<div class="notes">
- 可扩展
- 完全可以自己定制
- 比如: Jira最新版，help-desk
</div>


	
# 如何应对

## 争论和扯皮？

![](images/jira/arguments.jpg)

<div class="notes">
一个故事，email
</div>

## 救火队员？

![](images/jira/fireman.jpg)

## 沟通和协调？

![](images/jira/images.jpeg)

## 自我管理？

![](images/jira/tasks.jpeg)


## 作为一个团队

![](images/jira/team.jpeg)

## 需要的是流程化

![](images/jira/to.jpg)



## 基本流程

![](images/jira/basic_workflow.png)

<div class="notes">
如何处理？很简单！
一般过程：4个步骤
提出问题，分析/分配问题，解决问题，验证问题
也就是，用户或测试/负责人/开发人员/测试人员
</div>

# Jira介绍

## 全球知名小公司</br>“高富帅”的CEO

![](images/jira/atlassian.png)

<div class="notes">
Jira， confluence，crowd：项目管理三剑客
出自Atlassian [ætlɑʒen]，澳大利亚, “全球知名小公司”
    创立于2002年，启动资金为1万美元 信用卡贷款
    第一年起便已经实现盈利, 2010财年收入5900万美元
大名鼎鼎的产品：
    bitbucket：分布式配置管理平台，sourceforge, git的强力竞争者
    JIRA：需求、缺陷管理
    confluence：企业级wiki，知识管理平台
    crowd：基于 Web 的单点登录系统

创始人兼CEO：Mike Cannon-Brookes，年轻，帅，有才--》
    开源社区OpenSymphony的创始人
    《Java Open source Programming》的合著者

Opensymphony 2010年11月份关闭
    诞生的高质量项目：（java）
      WebWork：MVC框架，后来被纳入struts2的核心
      Quartz ：任务调度
      OSWorkflow：工作流引擎
</div>


## JIRA的定位

- 问题跟踪系统(Issue Tracker)
- 协同各角色的工作(workflow)
- 促进交流和反馈(Notify and Subscribe)

## 事件的分类

![](images/jira/issue_types.png)

------------------

![](images/jira/issue_create.png)


## 事件的属性

![](images/jira/issue_attributes.png)

------------------

![](images/jira/issue_attribute_create.png)

## 针对事件的行动

![](images/jira/actions.png)

<div class="notes">
很容易想到，用状态机来管理事件的状态变迁
核心的四个状态，对应前面的四个核心步骤

增加直接的通路：松散控制
增加回路和reopened状态：适应现实的复杂性

很多缺陷/需求处理流程都是这个状态机的子集

Jira lets you prioritise, assign, track, report and audit your 'issues'

- create an issue(types)
- after creating(details)
- add comments

</div>

## Ticket

![](images/jira/ticket.jpg)

Ticket，用于跟踪

在项目开发过程中出现的任何事件，都可以用一个Ticket来标识，例如Bug，项目计划，功能改进，项目建议，Todo等等，都可以写成一个Ticket，开发人员通过访问查看Ticket系统，可以及时的了解到项目进度，有待解决的地方等等
每个Ticket都可以被修改和说明（Description属性），并说明这个Ticket是Bug还是项目建议还是其他什么（Type属性），指派由哪个人对这个Ticket负责（Assigned to/Owner属性），设定Ticket的优先级（Priority属性），设定Ticket的最终完成时间（Milestone属性），设定这个Ticket属于哪个模块（Component属性）。


## 项目状态

![](images/jira/project1.png)

<div class="notes">
以上是针对单个事件
整个项目，图表统计
30天汇总, 已创建 vs 已解决

reporting and statistics
支持图形和图表的个性化的报表，可以监控所有issues的进程
</div>	

------------------

![](images/jira/project_pie.png)

<div class="notes">
项目事件状态
</div>	
------------------

![](images/jira/project2.png)

<div class="notes">
按各种指标分类汇总
</div>

------------------

![](images/jira/project_others.png)

## portal

![](images/jira/portal1.png)

<div class="notes">
上面报表的集成
可定义，可分享
</div>	

------------------

![](images/jira/portal2.png)


## 邮件通知

![](images/jira/notify_settings.png)

## 订阅项目活动

![](images/jira/rss.png)

## 小结：基本概念

![](images/jira/JIRA_Hierarchy.png)


## 小结：Jira的用途

can use as

- bugs/changes requests tracking
- help-desk/support/customer service
- project management
- task tracking
- requirements managment
- workflow/process mgnt


## JIRA的特点

- 基于Web
- 开源，不免费
- 多种“事件”类型
- 自定义事件字段
- 可定义的工作流
- 更强大的权限管理
- 时效管理
- 自定义dashboard
- 上传附件
- 和cvs/svn的集成


# Demo

<div class="notes">
操作示例
<div>


## 

- 创建issue
- 操作issue (comment &sdot; assign &sdot; watch &sdot; workflow)
- 子任务
- 导航和搜索
- 过滤器 (创建 &sdot; 分享)
- 报告(report)
- Dashboard( 自定义 &sdot; 分享)
- 通知和订阅

# Powered by

<div class="notes">
others
</div>

## 

- Markdown
- reveal.js
- github

<div class="notes">
关于轻量级presentation
</div>

# Q&A



