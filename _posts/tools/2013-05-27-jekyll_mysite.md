---
layout: post
title: "Jekyll建站过程"
description: "本站建立过程中的一些经验，不断完善中..."
category: 工具使用
tags: [jekyll, github]
imgroot: "/images/posts/tools/jekyll_mysite/"
---
{% include page_setup %}

##基础篇##
---

###关于Jekyll###

![Jekyll](/images/posts/tools/jekyll_mysite/jekyll.jpg)

已经有太多的文章介绍了[Jekyll](http://jekyllrb.com/)(/'dʒiːk əl/)。
简单的说，Jekyll是用ruby语言实现的一个静态网站生成器，可以将[Markdown][1] (或者[Textile][2])编辑的文档生成html。
当然也可以用来生成博客。

Jekyll支持[Liquid][3]模板语言，写文档时的感觉很像是在写Django模板。在文档中可以使用[Jekyll内置的变量][4]
以及[在文档中定义的变量][5]。

与RoR一样，Jekyll也可以通过插件来增加额外的功能。


[1]:http://daringfireball.net/projects/markdown/
[2]:http://textile.sitemonks.com/
[3]:http://wiki.shopify.com/Liquid
[4]:http://jekyllrb.com/docs/variables/
[5]:http://jekyllrb.com/docs/frontmatter/


###关于github Pages###

[github][]是程序员的facebook。[github Pages][6]是github提供的静态网页托管。可以为用户或者项目创建站点。
有意思的是，github Pages对于上传的静态文件会通过Jekyll进行处理后再发布出来。

于是，一些”不务正业“的程序员就开始使用github Pages建立博客，现在这股风潮已经愈演愈烈，一些程序员聚集的博客站点可能要小心应对了。

[github]:https://github.com/
[6]:http://pages.github.com/

###使用github Pages写博客的好处###
为什么说”一些程序员聚集的博客站点可能要小心应对了“呢？ 因为github Pages简直是为程序员量身定制的博客系统。
（当然，估计也只有程序员会愿意折腾这些事情）。

使用github Pages写博客的好处主要体现在以下方面：



###发布文章###

在_posts文件夹中，可以创建子目录。

必须使用
    YEAR-MONTH-DAY-title.MARKUP
的形式命名，比如：
    2011-12-31-new-years-eve-is-awesome.md
    2012-09-12-how-to-write-a-blog.textile


##进阶篇##
---

###抛弃Jekyll bootstrap###
JB/

###处理图片
page_url

###处理表格

###博客搬家


gem install jekyll-import --pre

###markdown编辑工具###

####vim####

####Sublime Text2####

####emacs####


##推广篇##
---

###墙内墙外（TODO）###
增加了facebook, twitter等在墙内“不存在”的东西，需要考虑如何不拖慢墙内用户的访问速度。
