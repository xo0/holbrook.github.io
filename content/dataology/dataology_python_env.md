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


# Anaconda

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

# ipython, jupyter 和 spyder

python 本身提供了类似shell的交互式解释器，但是并不好用， [IPython](http://ipython.org/) 对其进行了极大加强。

不仅如此，IPython 还提供了 web 方式的 IPython notebook(现在叫做[jupyter](https://jupyter.org/))，
已经成为Python科学计算界的标准配置。

如果你喜欢像 R 一样的 GUI 程序，可以使用命令`jupyter qtconsole`打开一个图形界面。

如果喜欢 RStudio，可以使用 `spyder`.

（附：可能是 IPython notebook 太好用了，
RStudio 现在也实现了一个类似的 web 交互工具 [shiny](https://www.rstudio.com/products/shiny/))。


# NumPy

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

# SymPy

-符号运算好帮手

    从例子开始
    数学表达式
    符号运算
    其它功能

# matplotlib

- 绘制精美的图表

    快速绘图
    Artist对象
    坐标变换和注释
    绘图函数简介

# Traits

- 为Python添加类型定义

    开发背景
    Trait属性的功能
    Trait类型对象
    Trait的元数据
    预定义的Trait类型
    Property属性
    Trait属性监听
    Event和Button属性
    Trait属性的从属关系
    动态添加Trait属性
    创建自己的Trait类型

# TraitsUI
- 轻松制作用户界面

    缺省界面
    用View定义界面
    用Handler控制界面和模型
    属性编辑器
    菜单、工具条和状态栏
    设计自己的编辑器

# Chaco

- 交互式图表

    面向脚本绘图
    面向应用绘图
    添加交互工具
    二次开发

# TVTK

- 数据的三维可视化

    流水线(Pipeline)
    数据集(Dataset)
    可视化实例
    TVTK的改进

# Mayavi

- 更方便的可视化

    用mlab快速绘图
    Mayavi和TVTK的关系
    Mayavi应用程序
    将Mayavi嵌入到界面中

# VPython

- 制作3D演示动画

    场景、物体和照相机
    制作动画演示
    与场景交互
    用界面控制场景
    创建复杂模型

# OpenCV

- 图像处理和计算机视觉

    储存图像数据的Mat对象
    图像处理
    图像变换
    图像识别

# matplotlib

- 绘制精美的图表

    绘图后台
    事件、动画与控件

# Pandas

- 方便的数据分析库

    分析Pandas项目的提交历史
    兼并数组和字典功能的Series

# Cython

- 编译Python程序

    计算矢量集的距离矩阵
    Cython是如何编译的
    使用Python标准对象和API
    扩展类型(cdef类)






- matplotlib - For graphical visualisation of data
- pandas - For data "wrangling" and time series analysis
- scikit-learn - For machine learning and artificial intelligence algorithms

Pandas 数据分析
Statsmodels 统计包
Matplotlib 绘图
scikit-learn机器学习
seaborn绘图
statsmodels统计分析

深度学习:
    PyTorch


# 参考资料

[^1]: [Python科学计算发行版—Anaconda](http://www.cnblogs.com/super-d2/p/4725818.html)
[^2]: [用Python做科学计算](http://hyry.dip.jp/tech/book/page/scipy/index.html)
[^3]: [用Python做科学计算(第二版)](http://hyry.dip.jp/tech/book/page/scipynew/index.html)
[^4]: [Comprehensive learning path – Data Science in Python](https://www.analyticsvidhya.com/learning-paths-data-science-business-analytics-business-intelligence-big-data/learning-path-data-science-python/)
