Title: 利用Python进行数据分析(5)：Pandas 入门
Date: 2017-02-23
Category: 数据科学
Tags: 读书笔记, python
Summary:
    《[利用Python进行数据分析](https://book.douban.com/subject/25779298/)》读书笔记。
    第 5 章：Pandas 入门。
    NumPy虽然提供了方便的数组处理功能，但是它还是缺少许多数据处理、分析所需的一些快速工具。
    Pandas基于NumPy构建，提供众多更高级的数据处理功能，使得以 NumPy 为中心的数据处理工作更便捷。


NumPy虽然提供了方便的数组处理功能，但是它还是缺少许多数据处理、分析所需的一些快速工具。
Pandas基于NumPy构建，提供众多更高级的数据处理功能，使得以 NumPy 为中心的数据处理工作更便捷。

pandas的作者在设计 Pandas 时，主要考虑以下几个方面：

- 按轴自动或显式数据对齐功能的数据结构

  来自不同数据源的数据，由于各数据源的索引方式不同，经常会出现数据未对齐，而这会导致很多常见错误。

- 集成时间序列功能
- 既能处理时间序列数据也能处理非时间序列数据的数据结构
- 数学运算和简约（比如对某个轴求和）可以根据不同的元数据（轴编号）执行
- 灵活处理缺失数据
- 合并及其他出现在常见数据库（例如基于SQL的）中的关系型运算

引入 Pandas 的约定为：

```
from pandas import Series, DataFrame
import pandas as pd
```

本章内容较多，每节的内容拆分成一个 ipython notebook:

- [数据结构](/2017/02/24/python_data_analysis5-1.html)
- [基本功能](/2017/02/24/python_data_analysis5-2.html)
- [汇总和描述性统计](/2017/02/27/python_data_analysis5-3.html)
- [处理缺失数据](/2017/02/28/python_data_analysis5-4.html)
- [层次化索引]()
- [其他]()


