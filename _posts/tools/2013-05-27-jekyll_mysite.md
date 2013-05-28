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

Jekyll支持[Liquid][3]模板语言，写文档时的感觉很像是在写Django模板。Jekyll定义了一些[内置的变量][4]，包括全局变量、页面变量等。
[在文档中可以设置页面变量的值][5]。

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

对我来说，使用github Pages写博客的好处主要体现在以下方面：
1. 自由，随意定制
2. 方便，在github上托管
3. 可控，有版本管理
4. 直接，只需提交，不需要先导出再提交，让人愿意持续更新文章
5. 高效，使用markdown语言能提高写作的效率（但是个人觉得不如org-mode)
6. 免费，无限流量，无限空间

###关于Jekyll Bootstrap

[jekyll-bootstrap](http://jekyllbootstrap.com/)是用Jekyll建立博客的一套模板，提供了主题（themes)、评论、。。等功能，

对于Jekyll的初学者能提供很大的帮助，其网站上号称“基于GitHub Pages建博客的最快方式”，可以“用3分钟就建立一个博客”。


###3分钟建立博客

让我们看看上述工具的组合如何用3分钟建立博客。假设你已经有git的基础，在github上托管过项目。并且使用的不是windows。

    # 检查ruby版本
    ruby -v
    #如果不是1.9.3+，需要升级到1.9.3
    gem install rvm
    rvm install 1.9.3
    # 安装jekyll, 并使用rdiscount作为markdown解析器
    sudo gem install jekyll
    gem search rdiscount

    # 使用Jekyll-Bootstrap，其实就是一个复制的过程。下面的USERNAME代表你在github上的用户名
    git clone https://github.com/plusjade/jekyll-bootstrap.git USERNAME.github.com


    # 使用GitHub Pages的账户主页建立博客，必须使用如下形式的项目名称并使用主分支
    # 如果使用项目主页，必须使用项目的gh-pages分支
    cd USERNAME.github.com
    git remote set-url origin git@github.com:USERNAME/USERNAME.github.com.git
    git push origin master

    好了，等上几分钟，你的主页就发布在了https://USERNAME.github.com。

###其他操作

####jekyll命令

安装jekyll会产生一个命令行工具：jekyll，提供以下功能：

    build                Build your site                
    doctor               Search site and print specific deprecation warnings            
    help                 Display global or [command] help documentation.                        
    import               Import your old blog to Jekyll         
    new                  Creates a new Jekyll site scaffold in PATH             
    serve                Serve your site locally 

####Rakefile

Jekyll-Bootstrap提供了一个Rakefile（ruby的makefile），包含一些博客相关的任务（task），包括：

    $ rake -T
    rake page           # Create a new page.
    rake post           # Begin a new post in ./_posts
    rake preview        # Launch preview environment
    rake theme:install  # Install theme
    rake theme:package  # Package theme
    rake theme:switch   # Switch between Jekyll-bootstrap themes.


	


##进阶篇##
---

###放弃Jekyll bootstrap###

Jekyll bootstrap确实能带来一些变量，但是和RoR一样，充满了各种puzzle。 
更加让中国人不爽的是，作者将其缩写定义为“JB”。

经过初步的尝试后，我决定放弃JB，用原生的Jekyll来构建博客，让一切都在掌控之中。


###Jekyll的目录结构（TODO）



###发布博客文章(TODO)

在_posts文件夹中，可以创建子目录。

必须使用
    YEAR-MONTH-DAY-title.MARKUP
的形式命名，比如：
    2011-12-31-new-years-eve-is-awesome.md
    2012-09-12-how-to-write-a-blog.textile

###灵活的导航

使用静态的导航菜单会带来两个问题：

1. 文档过长
2. “当前项”的高亮不好处理

可以在_config.yml中设置一个导航菜单的变量：

    menuitems:
    - name:			首页
      url:          /index.html
    - name:		  	分类
      url:          /categories.html
    - name:		  	标签
      url:          /tags.html
    - name:		  	归档
      url:		  	/archive.html			
    - name:		  	读书
      url:		  	/reading.html			
    - name:		  	工作
      url:		  	/working.html			
    - name:		  	关于
      url:		  	/about.html	
    
然后在模板的导航部分可以这样写：

    <ul class="nav">
      {/% for item in site.menuitems %/}
        {/% if item.url == page.url %/}
        <li class="active">
        {/% else %/}
        <li>
        {/% endif %/}
        <a href="{{item.url}}">{{item.name}}</a>
        </li>
      {/% endfor %/}
    </ul>

###处理图片(TODO)
page_url

###处理表格(TODO)

###博客搬家（TODO）

用Jekyll写博客的，通常不会是新博主，会存在博客搬家的需求。

Jekyll提供了一个import的子命令(需要插件jekyll-import），可以将旧的博客导入到Jekyll。


[exitwp](https://github.com/thomasf/exitwp)是一个用python开发的工具，号称是将wordpress的博客导出并转换成markdown，但实际上
任何能导出rss/atom的博客都可以用这个工具进行转换。

    git clone https://github.com/thomasf/exitwp
    sudo pip install --upgrade  -r pip_requirements.txt
    cd exitwp/wordpress-xml/
    wget http://your/atom/file/xml
    cd ..
    python exitwp.py




###markdown编辑工具###

####vim####

####Sublime Text2####

####emacs####


##推广篇##
---

###使用域名

域名的好处不言而喻。

###墙内墙外（TODO）###
增加了facebook, twitter等在墙内“不存在”的东西，需要考虑如何不拖慢墙内用户的访问速度。
