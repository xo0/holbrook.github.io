---
layout: post
title: "Salt state 配置详解"
description: ""
category: 工具使用
tags: [devops, salt, python]
lastmod: 
---

![salt_functions](/images/2013/salt_usage/salt_state_config_structure.png)

目标：通过master管理多个mision的状态。

体系：

- state tree
- environment
- top.sls

实现：文件系统（文件夹和SLS文件）

示例：

