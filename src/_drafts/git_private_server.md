Gitolite+gitlab+redmine

在这个什么都讲究“分布式”的年代，没有理由不使用Git管理代码和文档。与传统的版本管理工具相比，Git即可以本地提交，又方便远程协作。

Git可以管理很多东西，比如代码，博客，以及配置。但是GitHub的私有库太贵了，而且一些配置文件放在公共资源上总觉得心理不那么踏实。
于是有了自建Git服务器的需求。

Git是个好东西，但是我们与Linus之间存在着太大的差距。最开始，人们抱怨Git晦涩难懂，后来人们发现Git确实是个好东西，但又不适应其GNU精神。

Git最初的设计是没有任何权限上的限制，一切权限取决于你在Linux系统上的用户。但是权限有过于粗糙——针对整个库(repository)。
这让许多小伙伴都惊呆了：要知道，很多公司内部的不同项目之间都是不能共享代码的！

可以，熟悉了Git的用户又对其欲罢不能，再也不想回去使用SVN，或者CVS。于是有了如下工具：

- [Gitolite](https://github.com/sitaramc/gitolite): 实现了对Git库(repository)权限的细粒度管理，使用perl编写。目前已经完全取代了Gitosis的地位
- [GitLab](http://gitlab.org/)，GitHub的模仿者，你可以搭建GitHub私服。当然，没有Pages, 也不支持Fork。其实Fork这个功能对企业内部来说没啥必要，而且每次看到某些网站上的彩带我都会邪恶的联想到“Fuck me on the GitHub”（请宽恕我吧）

- [RedMine](): GitLab/GitHub还是有点散漫的感觉。为了让项目严肃起来，还可以用RedMine包装一下。也可以让“PMO”能够看得懂项目组那群家伙到底在干嘛——这样会节省项目组相当多的时间，相信我！


功能逻辑图

要用它干嘛？

安装配置
