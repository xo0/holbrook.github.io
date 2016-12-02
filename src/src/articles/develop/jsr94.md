---
layout: post
title: "Java规则引擎规范：JSR94"
date: 2012-12-07
description: "Java World似乎总会出现一些接口规范，这样做的好处是可以面向接口编程，可以在实现了该接口的产品/组件之间自由切换，避免被厂商绑架。 本文要介绍的JSR94:Java Rule Engine API，Java规则引擎API规范。"
category: 软件开发
tags: [规则引擎,JSR]
---

Java World似乎总会出现一些接口规范，这样做的好处是可以面向接口编程，可以在实现了该接口的产品/组件之间自由切换，避免被厂商绑架。 本文要介绍的[JSR94:Java Rule Engine API](http://jcp.org/aboutJava/communityprocess/final/jsr094/index.html)，
Java规则引擎API规范。

# 概述

JSR-94是JCP(Java Community Process)制定的关于Java规则引擎API的规范，包括接口定义和示例代码。于2004年8月发布。 JSR-94定义了javax.rules和javax.rules.admin,前者包含了Java规则引擎运行时（Rumtime)API及异常（Exception）定义，后者包含了规则管理相关的API和异常定义。

# 规则管理API

规则管理API在javax.rules.admin中定义,主要包括以下类/接口：

![javax.rules.admin](images/rule-engine/javax.rules.admin.png)


- Rule：规则实体
- RuleExecutionSet：执行集，某个规则对应的动作
- LocalRuleExecutionSetProvider：用于从本地创建执行集，如InputStream,Reader等
- RuleExectuionSetProvider：用于从本地或远程创建执行集，如xml Element，Serializable等
- RuleAdministrator：用于获取ExecutionSetProvider，并管理执行集的注册/注销


规则管理API实现的功能包括：

1. 装载规则（Rule）和执行集（RuleExecutionSet)
2. 执行集的注册/注销,只有注册的执行集对应的规则才能被客户访问


# 运行时API

运行时API在javax.rules中定义，主要包括以下类/接口：

![javax.rules](images/rule-engine/javax.rules.png)

- RuleServiceProviderManager: 通过URL注册/注销RuleServiceProvider
- RuleServiceProvider: 提供对RuleRuntime和RuleAdministrator的访问
- RuleRuntime: 规则引擎运行时，可以创建规则会话
- RuleSession: 规则会话，用于执行规则
- RuleExecutionSetMetaData: 执行集元数据，包括name,url,description等。执行集元数据会被RuleSession使用
- StatelessRuleSession: 无状态规则会话
- StatefulRuleSession: 有状态规则会话
- Handle和ObjectFilter: 有状态会话维护会话状态的帮助类

规则引擎运行时API实现的功能包括：

1. 注册/注销规则引擎实例，只有注册的规则引擎实例才能被使用
2. 从注册的规则引擎实例创建Runtime
3. 从Runtime创建会话，包括有状态和无状态两种会话
4. 通过会话执行规则

# 异常定义

除了前面提到的主要类/接口外，JSR94还规定了规则引擎运行时及管理的一些异常，如下：

![javax.rules.exceptions](images/rule-engine/javax.rules.exceptions.png)


# 代码示例

下面是使用Drools作为规则引擎实例的一个例子，规则文件使用了Drools的drl格式：

JSR94Sample.java

```java

package com.sample;

import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.rules.ConfigurationException;
import javax.rules.RuleRuntime;
import javax.rules.RuleServiceProvider;
import javax.rules.RuleServiceProviderManager;
import javax.rules.StatelessRuleSession;
import javax.rules.admin.LocalRuleExecutionSetProvider;
import javax.rules.admin.RuleAdministrator;
import javax.rules.admin.RuleExecutionSet;

import org.drools.jsr94.rules.RuleServiceProviderImpl;

public class JSR94Sample {
    private static RuleServiceProvider ruleProvider;

    private static void initProvider(){
        String uri = RuleServiceProviderImpl.RULE_SERVICE_PROVIDER;
        Class providerClass = RuleServiceProviderImpl.class;

        try{
            //注册ruleProvider
            RuleServiceProviderManager.registerRuleServiceProvider(uri, providerClass);

            //从RuleServiceProviderManager获取ruleProvider
            ruleProvider = RuleServiceProviderManager.getRuleServiceProvider(uri);
        }catch(ConfigurationException e){
            e.printStackTrace();
        }
    }

    private static void adminSample(){


        try{
            //获取RuleAdministrator实例
            RuleAdministrator admin = ruleProvider.getRuleAdministrator();

            //获取RuleExectuionSetProvider
            HashMap properties = new HashMap();
            properties.put("name", "My Rules");
            properties.put("description", "A trivial rulebase");

            LocalRuleExecutionSetProvider ruleExecutionSetProvider = admin.getLocalRuleExecutionSetProvider(properties);

            //创建RuleExecutionSet
            FileReader reader = new FileReader("bin/sample.drl");
            RuleExecutionSet reSet = ruleExecutionSetProvider.createRuleExecutionSet(reader, properties);

            //注册RuleExecutionSet
            admin.registerRuleExecutionSet("mysample",reSet,properties);
        }catch(Exception e){
            e.printStackTrace();
        }

    }


    private static void runtimeSampe(){
        try{
            //获取RuleRuntime, 创建会话
            RuleRuntime runtime = ruleProvider.getRuleRuntime();
            StatelessRuleSession ruleSession = (StatelessRuleSession)runtime.createRuleSession("mysample",null,RuleRuntime.STATELESS_SESSION_TYPE);

            //初始化输入数据
            Message message1 = new Message();
            message1.setMessage("Hello World");
            message1.setStatus(Message.HELLO);

            Message message2 = new Message();
            message2.setMessage("Goodbye World");
            message2.setStatus(Message.GOODBYE);


            List inputs = new ArrayList();
            inputs.add(message1);
            inputs.add(message2);

            //执行规则
            List<Message> results = ruleSession.executeRules(inputs);
            for(int i=0;i<results.size();i++){
                Message msg = results.get(i);
                System.out.println(msg.message);
            }


            //释放会话资源
            ruleSession.release();

        }catch(Exception e){
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {
        // TODO Auto-generated method stub
        initProvider();
        adminSample();
        runtimeSampe();
    }


    public static class Message {

        public static final int HELLO = 0;
        public static final int GOODBYE = 1;

        private String message;

        private int status;

        public String getMessage() {
            return this.message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public int getStatus() {
            return this.status;
        }

        public void setStatus(int status) {
            this.status = status;
        }

    }

}

```

规则文件使用的就是[这里](/2012/12/06/rule_language.html)的例子。

# 实现JSR94的产品

主要的一些实现了JSR94的规则引擎产品如下：

- [Drools](http://www.jboss.org/drools/): 	开源	DRL,xDRL,DSL,Decision Table	ReteOO	Eclipse,excel	文件系统	jar
- [Mandarax](http://mandarax.sourceforge.net/): 	开源	RuleML
- [OpenRules](http://openrules.com/): 	开源	Decision Table	Rete	excel	 	war
- [JLisa](http://jlisa.sourceforge.net/): 	开源
- [Blaze](http://www.fico.com/en/Products/DMTools/Pages/FICO-Blaze-Advisor-System.aspx): 	商业	SRL
- [WebSphere ILOG JRules](http://www-01.ibm.com/software/integration/business-rule-management/jrules-family/): 	商业
- [JESS](http://herzberg.ca.sandia.gov/): 	商业

# 小结

JSR94为规则引擎提供了公用标准API,为实现规则管理API和运行时API提供了指导规范, 目前已经获得很多开源/商业规则引擎产品的支持。 但是JSR94没有对[规则的描述语言](/2012/12/06/rule_language.html)进行规范，导致各规则引擎产品大多采用自己私有的描述语言。
