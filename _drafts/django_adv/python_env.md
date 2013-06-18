
Python中的easy_install很好很强大，后起之秀pip更是青出于蓝。有人说python中的easy_install就像ruby中的gem，perl中的cpan，我一直使用Ubuntu，因此想到的类比是debian系列中的apt。easy_install如此常见以致有不少同学以为easy_install是linux的一个命令。强大的软件包管理工具必然有一个不弱小的软件包仓库。Python的官方软件包仓库就是大名鼎鼎的PyPI。通常情况下我们都是使用easy_install或pip从PyPI仓库下载软件包并安装，很方便。但如果网络状况不好或没有网络的话这就很麻烦。幸好，Python提供了Pypi服务器软件，使得可以在本地搭建一个pypi镜像服务器，然后就可以使用自己的镜像服务器来下载安装了。


这几天我玩儿python和django
倒是有点意思
pip相当于gem
visualenv相当于rvm
中的gemset



http://clemesha.org/blog/2009/jul/05/modern-python-hacker-tools-virtualenv-fabric-pip/

virtualenv：用于创建一个隔离的Python环境。

Fabric：用于最小化将本地开发的代码部署到远程服务器上这一繁琐的重复性工作。

pip：最先进的Python软件包管理工具。

使用经验日后奉上。



可以搭建自己的pypi服务器

