Title: 基于Python的数据科学环境
Date: 2017-02-11
Category: 数据科学
Tags: python, env
Summary:
    在[《数据科学的知识体系》](http://holbrook.github.io/2017/02/05/index.html)中，
    列出了进行数据科学研究所需的知识。但Swami Chandrasekaran明显更喜欢 R 。
    我个人更倾向于 python。而且 python 和 R可以互相调用[]
    本文列出数据科学相关的 python 模块。


在[《数据科学的知识体系》](http://holbrook.github.io/2017/02/05/index.html)中，
列出了进行数据科学研究所需的知识。但Swami Chandrasekaran明显更喜欢 R 。
我个人更倾向于 python。至于为什么不是 R 或 Matlib，可以参考
[《R vs Python vs matlab: the quant language war》](https://futures.io/matlab-r-project-python/33828-r-vs-python-vs-matlab-quant-language-war.html)和
[《R和Python的相遇》](http://nbviewer.jupyter.org/gist/xccds/d692e468e21aeca6748a)。

其实，R 和 python 的边界也不是那么的无法逾越，
可以使用[rpy2](https://rpy2.bitbucket.io/)在 python 中调用 R，
也可以使用[rPython](http://rpython.r-forge.r-project.org/)在 R 中调用 python。


# 运行环境

## Anaconda

尽管 Linux 和 Mac OS 自带了 python 环境，但还是推荐安装 [Anaconda](https://www.continuum.io)。

Anaconda是python的一个科学计算发行版，包含了众多流行的科学、数学、工程、数据分析的Python包[^1]。

从官方网站下载有点慢。如果用安装包进行安装，
可以从[清华大学开源软件镜像站(TUNA)](https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/)下载。
但还是建议[使用包管理器](http://holbrook.github.io/2017/02/11/windows_pkg_manager_chocolatey.html)
进行安装，安装后再配置TNUA 上Anaconda 仓库的镜像作为源：

```
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes
```

安装和配置完 Anaconda 后，可以使用其自带的 python 包管理器安装 python 模块，也可以使用常用的 `pip`。
但要注意环境的配置。比如：

```
conda --version  # 查看版本
conda install seaborn #
```

## ipython, jupyter 和 spyder

python 本身提供了类似shell的交互式解释器，但是并不好用， [IPython](http://ipython.org/) 对其进行了极大加强。

不仅如此，IPython 还提供了 web 方式的 IPython notebook(现在叫做[jupyter](https://jupyter.org/))，
已经成为Python科学计算界的标准配置。

如果你喜欢像 R 一样的 GUI 程序，可以使用命令`jupyter qtconsole`打开一个图形界面。

如果喜欢 RStudio，可以使用 `spyder`.

（附：可能是 IPython notebook 太好用了，
RStudio 现在也实现了一个类似的 web 交互工具 [shiny](https://www.rstudio.com/products/shiny/))。


## Cython

编译Python程序，提高性能。


# 底层库

## NumPy

python 中本来提供了 列表(list) 和 数组(array), 可以用来构建矩阵。
但是这些都是通用数据结构，对于纯数值运算来说效率不高。而且没有矩阵运算的函数。

[NumPy](http://www.numpy.org/) 弥补了这些不足，为线性代数的计算提供了极大帮助。
NumPy 定义了ndarray(N维数组对象，N-dimensional array object)和
ufunc(通用函数对象, universal function object)，
分别用于多维数组的存储和处理。
其中，ufunc 是一种能对数组的每个元素进行操作的函数。

Numpy是下面很多模块的基础模块。

# SciPy

[SciPy](http://www.scipy.org/)在NumPy的基础上增加了众多的数学、科学以及工程计算中常用的模块。
通过不同的子模块，SciPy 提供了线性代数、拟合与优化、差值、数值积分、图像处理、系数矩阵处理等函数。

Numpy 已经提供了线性代数函数库，但是SciPy的线性代数库比NumPy更加全面。

# matplotlib

[Matplotlib](http://matplotlib.org/)为 python 提供了一整套和MATLAB类似的绘图函数集。
Matplotlib 很强大，但是比较底层。高级的python 数据处理模块会调用 Matplotlib 实现更简单的绘图函数，
比如后面要提到的 Pandas, Seaborn等。
但是要对图表进行精细的、个性化的调整时，还是需要掌握 Matplotlib 的函数。

# 数据分析和处理

## Pandas

[Pandas](http://pandas.pydata.org/), Python Data Analysis Library,
是 python 数据分析领域里程碑式的一个重要工具。

Pandas 基于 NumPy, 实现了`Series(序列)`和类似 R的 `DataFrame` 对象，
提供了大量能使我们快速便捷地处理数据的函数和方法。

Pandas 很好的解决了数据分析的大部分任务，是所有中等规模数据分析的最有效的工具。

## Statsmodels

[Statsmodels](http://statsmodels.sourceforge.net/)
是 Python 中一个强大的统计分析包，包含了描述统计、回归分析、时间序列分析、假设检验等等的功能。

一些主要的功能包括：


- Linear regression models
- Generalized linear models
- Discrete choice models
- Robust linear models
- Many models and functions for time series analysis
- Nonparametric estimators
- A collection of datasets for examples
- A wide range of statistical tests
- Input-output tools for producing tables in a number of formats (Text, LaTex, HTML) and for reading Stata files -into NumPy and Pandas.
- Plotting functions
- Extensive unit tests to ensure correctness of results
- Many more models and extensions in development



## SymPy

[SymPy]()是Python的数学符号计算库，目标是成为一个全功能的代数系统。
SymPy支持符号计算、高精度计算、模式匹配、绘图、解方程、微积分、组合数学、离散数学、几何学、概率与统计、物理学等方面的功能。

# 可视化

## Seaborn

[Seaborn](http://seaborn.pydata.org/)
是基于 Matplotlib 的高级统计绘图工具（类似 Pandas 与 NumPy 的关系），其功能类似 R 中的 lattice。
Matplotlib很强大，但是也很复杂。因此推荐一开始使用Seaborn。

## Bokeh

[Bokeh(Bokeh.js)](http://bokeh.pydata.org/en/latest/docs/user_guide.html)
是一个 Python 交互式可视化库，支持现代化 Web 浏览器，提供非常完美的展示功能。

Bokeh 的目标是使用 D3.js 样式提供优雅，简洁新颖的图形化风格，同时提供大型数据集的高性能交互功能。

Boken 可以快速的创建交互式的绘图，仪表盘和数据应用。

## TVTK

数据的三维可视化


## VPython

制作3D演示动画


## OpenCV

图像处理和计算机视觉


# 机器学习

## scikit-learn

For machine learning and artificial intelligence algorithms

## PyTorch

深度学习


# Enthought Tool Suite

[Enthought Tool Suite](http://code.enthought.com/projects/index.php)是
[Enthought公司](http://code.enthought.com/)开发的开源科学计算一套应用程序开发包。
包含了大量的工具。主要的工具包括：

## Traits

Explicit type declarations; validation; initialization; delegation; notification; visualization.

## TraitsUI

A UI layer that supports the visualization features of Traits. Implementations using wxWidgets and Qt are provided by the TraitsBackendWX and TraitsBackendQt projects.


## Chaco

交互式 2D 图表

## Mayavi

交互式 3D 图表


## 其他

- Enaml
  Library for creating professional quality user interfaces combining a domain specific declarative language with a constraints based layout.
- Envisage
  Python-based framework for building extensible (plugin-based) applications.
- Pyface
  toolkit-independent GUI abstraction layer, which is used to support the "visualization" features of the Traits package.
- BlockCanvas
  Visual environment for creating simulation experiments, where function and data are separated using CodeTools.
- GraphCanvas
  library for interacting with visualizations of complex graphs.
- Enable
  Object drawing library and PDF vector drawing engine.
- SciMath
  Convenience libraries for math, interpolation, and units
- Casuarius
  supports constraints based layout in Enaml by wrapping Cassowary.
- AppTools
  General tools for ETS application development: scripting, logging, preferences, ...
- EnCore
  Core tools for application development (only depends on the Standard library).
- and more...


# 参考资料

[^1]: [Python科学计算发行版—Anaconda](http://www.cnblogs.com/super-d2/p/4725818.html)
[^2]: [用Python做科学计算](http://hyry.dip.jp/tech/book/page/scipy/index.html)
[^3]: [用Python做科学计算(第二版)](http://hyry.dip.jp/tech/book/page/scipynew/index.html)
[^4]: [Comprehensive learning path – Data Science in Python](https://www.analyticsvidhya.com/learning-paths-data-science-business-analytics-business-intelligence-big-data/learning-path-data-science-python/)
[^5]: [Python for statistical computing](http://aliquote.org/memos/2011/02/07/python-for-statistical-computing)
