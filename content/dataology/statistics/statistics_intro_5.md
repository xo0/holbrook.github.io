title: 《统计学》读书笔记(5/17:简单统计推断：总体参数的估计)
date: 2013-07-09
Category: 数据科学
Tags: 读书笔记, 统计学
summary: 统计学：从数据到结论，ISBN：9787503749964，作者：吴喜之 @[豆瓣](http://book.douban.com/subject/2193810/)


统计推断(statistical inference)：从数据得到关于现实世界的结论的过程。

由于统计学的研究对象是不可能穷举的大量个体，通常需要通过抽样方法得到样本，再用样本去推断总体的情况，
所以统计推断得出的不是一个精确的结论，而是近似结果。

统计推断的两个重要的方法是：

- 估计(estimation)
- 假设检验(hypothesis testing)

本章介绍估计，下一章介绍假设检验

# 5.1 用估计量估计总体参数

## 假定分布族

在通过样本信息推断总体情况之前，先假设总体的属性复合某种分布特征（分布族）。比如：

- 假设身高符合正态分布族
- 假设对某个观点的认同与否符合二项分布族

这些假设一半是通过经验获得，无法明确的证明。

## 确定具体分布

一个分布族下面的各种分布只是参数不同，通过研究样本确定这些参数，也就确定了具体分布。

常见的分布参数：

- 总体均值
- 总体标准差
- 成功概率

正态分布由总体均值和标准差两个参数决定；
Bernoulli分布由概率一个参数决定

确定参数的过程是一个估计的过程，来源于样本数据。

通过样本计算的各种统计量中，用于估计的统计量称为估计量（estimator)。

估计量随样本的不同具有随机分布；对于给定的样本有一个给定的值，称为估计值(estimate)。

两种估计：

- 点估计(point estimation)：用一个估计值来近似总体参数
- 区间估计(interval estimation)：用一个包括估计值在内的区间表示总体参数很可能处于的范围

# 5.2 点估计

任何统计量都可以作为估计量。

估计量的命名可以来自：

- 衡量一个估计量的好坏的某个标准
- 估计量的计算方式

常见的估计量：

- 样本均值：用于估计总体均值
- 样本标准差(s)：用于估计总体标准差
- 成功比例(x/n)：用于估计成功概率p

无偏估计量(unblased estimator)：多个样本产生的估计量的期望等于要估计的总体参数，这样的估计量称为无偏估计量。

上述三种估计量都是无偏估计量。


# 5.3 区间估计

为了更准确的表达估算量，通常采用点估计和区间估计结合的说法。比如：

估计值+置信区间+置信度

其中：

- 估计值是对总体量的点估计
- 置信区间(confidence interval)是以估计值为中心的区间估计，包括上限(upper bound)和下限(lower bound)
- 置信度（confidence level）是抽取大量样本时，该区间会覆盖样本估计值的比例


# 5.4 关于置信区间的注意点

置信度描述的是统计量覆盖总体参数的概率，而不是置信区间覆盖总体参数的概率

置信度越低，则置信区间越窄

# 5.5 小结（略）
