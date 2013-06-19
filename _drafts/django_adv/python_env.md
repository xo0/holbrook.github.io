# 包管理器

任何强大的体系结构都是提供一个基本的框架，并制定扩展的规范。
随着成千上万的开发者在其框架的基础上开发出越来越多的扩展，又提出了针对这些扩展进行管理的工具，
并建设出一个中心的“仓库”进行统一的登记以便检索和获取。


我们能举出很多这样的例子：

大到操作系统，可以有linux + 包管理器(apt, yum)， iOS + App Store, Android + Market;

应用软件，如 eclipse + marketplace, R + PCAN, 

编程语言如 perl + cpan, ruby + gem, python + easy_install/pip。



为了分享和管理python开发的大量模块，python阵营也建立了PyPI(the Python Package Index)仓库 ，并且在setuptools包中提供了easy_install命令，可以与PyPI配合实现python模块的自动安装。

pip是easy_install的改进版, 提供更好的提示信息，删除package等功能。

老版本的python中只有easy_install, 没有pip。

easy_install的用法：

1） 安装一个包
 $ easy_install <package_name>
 $ easy_install "<package_name>==<version>"

2) 升级一个包
 $ easy_install -U "<package_name>>=<version>"

pip的用法

1) 安装一个包
 $ pip install <package_name>
 $ pip install <package_name>==<version>

2) 升级一个包 (如果不提供version号，升级到最新版本）
 $ pip install --upgrade <package_name>>=<version>

3）删除一个包
 $ pip uninstall <package_name> 




 - python + 模块 + easy_install/pip

这里要说的就是python的xxx



Python中的easy_install很好很强大，后起之秀pip更是青出于蓝。
easy_install如此常见以致有不少同学以为easy_install是linux的一个命令。

强大的软件包管理工具必然有一个不弱小的软件包仓库。Python的官方软件包仓库就是大名鼎鼎的PyPI。

通常情况下我们都是使用easy_install或pip从PyPI仓库下载软件包并安装，很方便。

但如果网络状况不好或没有网络的话这就很麻烦。幸好，Python提供了Pypi服务器软件，使得可以在本地搭建一个pypi镜像服务器，然后就可以使用自己的镜像服务器来下载安装了。





http://clemesha.org/blog/2009/jul/05/modern-python-hacker-tools-virtualenv-fabric-pip/

virtualenv：用于创建一个隔离的Python环境。

Fabric：用于最小化将本地开发的代码部署到远程服务器上这一繁琐的重复性工作。

pip：最先进的Python软件包管理工具。

使用经验日后奉上。


接触了Ruby，发现它有个包管理工具RubyGem很好用，并且有很完备的文档系统http://rdoc.info
发现Python下也有同样的工具，包括easy_install和Pip。不过，我没有细看easy_install的方法，这就简单的介绍一下Pip的安装与使用：
准备：
$ curl -O http://python-distribute.org/distribute_setup.py
$ python distribute_setup.py
安装：
$ curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
$ python get-pip.py
使用方法：
$ pip install SomePackage
$ pip search "query"
$ pip install --upgrade SomePackage
$ pip install --upgrade SomePackage==version

补充：
包安装后的py文件路径：/usr/local/lib/python2.7/dist-packages




可以搭建自己的pypi服务器

# 虚拟环境

visualenv相当于rvm
中的gemset

对于类UNIX系统，Python通常作为系统分发的一部分（Ruby也是一样），他的包管理和PATH管理要相对混乱一些。通常我们有两种方式来安装一个Python的软件包：

sudo apt-get install python-redis
sudo easy_install redis
一种是通过系统的包管理工具（如apt-get）从系统的软件仓库里安装，一种是通过python自己的包管理工具（如easy_install / pip）从Python Cheese Shop中下载安装。这两种安装方式有什么不同呢。以Ubuntu为例，通过apt-get安装的python包通常会被放在 /usr/share/pyshared 或 /usr/lib/python2.6/dist-packages 中，相对应的，由easy_install安装的Python包，则存放在 /usr/local/lib/python2.6/dist-packages 中。Python启动后可以通过查看sys.path来了解当前的path情况。

除了安装到系统目录，easy_install可以通过 –user 选项来把软件包安装到用户目录 $HOME/.local/lib/python2.6/site-packages。不过无论是系统级别还是用户级别，python都很难在启动时管理Path，即任何时候python都可以访问安装在系统中的所有软件包。这导致了混乱的情况，导致编写的python软件难以进行依赖管理和移植（即使没有定义在setup.py中，很多依赖还是可以访问的）。

由此virtualenv营运而生，virtualenv帮助你创建一个独立的python运行环境。激活这个小环境之后，easy_install/pip仅仅安装软件到小环境，python仅能访问环境内部的site-packages，这样整个环境中的依赖关系就非常清楚，也保障了程序的移植性。这样，就将原本系统scope的python包管理级别改进为项目级别。
0 distribute  http://python-distribute.org/distribute_setup.py
1 pip
   $ pip install SomePackage
   $ pip search "query"
   $ pip install --upgrade SomePackage
   $ pip install --upgrade SomePackage==version
      pip uninstall package-name

PYTHONPATH

2 virtualenv
3 yolk
4 virtualenvwrapper 管理多个不同的虚拟环境
5 pythonbrew - Python多版本管理利器 多个python版本切换
6 Fabric：用于最小化将本地开发的代码部署到远程服务器上这一繁琐的重复性工作。
7 supervisor - Python进程管理工具