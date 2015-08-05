量化交易的知识体系(BOK,Body of Knowledge)


# 引言

# 知识体系

量化交易的本质是收集市场内或市场外与交易相关的数据，运用一定的分析方法，
构建出策略模型，并利用策略模型参与到市场交易的一系列过程。

对于该过程来说，有几方面必备的知识：

- 量化分析是方法
- 策略模型是目的
- 数据科学是手段
- 编写代码是工具

![量化交易过程](assets/quant_process.dot.png)

# 量化分析(metric)

上面的量化交易过程，其实就是量化分析方法在交易领域的应用。
因此，量化分析的理论和方法是量化交易的前提和基础,
在量化分析理论基础上开展量化交易，才不会发生很大的偏差。

量化分析的核心概念包括数据(data)，指标(measure)和信息(information):

![](assets/data_measure_info.png)

- 数据:具体的数值。但并没有明确的意义。
  数据之间可能有联系（如上图中相互重叠的数据），但是数据本身并没有记录这种联系。
  数据的联系（相关性）一定要通过谨慎的分析才能建立，否则很容易得出错误的结论。
- 指标:
- 信息:

而量化分析就是为了解决某个问题，收集数据并分组，
对每组数据进行处理得出改组数据的一系列指标，
将不同组数据及其指标进行关联得到有用的信息，
最终依靠这些信息解决问题这样一系列的过程。

![量化分析核心概念](assets/metric_concepts.png)




如果需要深入了解量化分析的内容，可以参考
[《量化：大数据时代的企业管理》](http://book.douban.com/subject/20423552/)。
尽管这本书是以“企业管理”作为切入点，但其中的原理和方法完全可以应用到量化交易领域。

# 数据科学

# 模型和算法
## 机器学习

# 数学基础
## 统计分析

量化分析不完全是统计学，但是量化分析需要统计学作为基础。


# 编程能力