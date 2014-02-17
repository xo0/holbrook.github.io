# 什么是静态博客

静态博客（Static Blog）。。就是静态网页组成的博客。与之对比的动态博客，也就是页面是动态生成的，博客内容依存于数据库，国内各大网站提供的博客系统大都是动态博客。
静态博客的页面可以是手工通过制作html页面来维护，这样的话博客最基本的按日期管理、文章分类等特征都得手工完成，这么笨拙的办法可能没人喜欢。于是现在多是使用辅助工具帮助生成整个博客站点，文章自动按照日期管理、有类别或者TAG分类、还融合了留言板等其他技术，octopress就是其中一员。

# markdown vs org-mode

用 markdown 写作，用 Jekyll 发布到 github 上面的 blog 产生了兴趣。因此决定一试，其打动我的是：
markdown 写作，直接文本写作，不需要管格式，专注内容。和 TeX、wiki 的思想接近
github 托管。有版本管理，速度快、时髦
但试了一段时间后又放下了，原因如下：
没有找到好的模版，自己写 css 太费劲，找的几个现成的又不满意
不支持数学公式。本来 Jekyll 是支持的，但 github 上的 Jekyll 不支持
对 markdown 也还是不太满意
为什么转到 org-mode 上了呢？用 emacs 发布 html 的功能早就用过 emacswiki、muse，后来也都放弃掉。org-mode 也早就听说过，但一直没有兴趣用。直到暑假期间，心血来潮，觉得用 emacs 写文档很爽，尤其是文字显式很漂亮。因此就尝试了 org-mode。orgmode 的 GTD 很出色，但我的主要目标是用来写文档。与 markdown 相比，orgmode 的优点有：
与 emacs 集成度高，支持好，开发活跃。能够在 emacs 内输出 html、pdf 等格式
制作 table 方便
能够在 emacs 内显式图片
对 latex 公式支持的好
支持 “文学编程” （orgmode 中叫 Bable），可以直接在文档内部运行程序片段，将结果（文字、图像、表格）嵌入到文档中
既然有这些优点，自然就想把它用到 blog 上。github 上有个 o-blog 是基于 orgmode 的，做得也很漂亮。但试用时总有错误，加上它还是复杂了点，就放弃了，转而直接利用 orgmode 的 publish html 的功能发布 blog。图的就是上面给出的相比markdown的几个优点。



# Jekyll, JB, octopress

jekyll, jb, octopress的目录结构，区别

什么是octopress

说到 octopress，得先说说 jekyll。 jekyll 可以把以日期为文件名的 markdown 格式的文本文件转换为html的静态博客。
Jekyll is a simple, blog aware, static site generator. It takes a template directory (representing the raw form of a website), runs it through Textile or Markdown and Liquid converters, and spits out a complete, static website suitable for serving with Apache or your favorite web server.
可以理解为jekyll是实际转化生成静态站点的脚本程序，而octopress是套在jekyll外的一层封装，使得最终生成的站点上有更好的UI，更有风格，并且有更丰富的辅助功能（留言、代码展示、视频）。与octopress类似的还有bootstrip。 我在公司里记录一些东西也在用，只是觉得 octopress 对移动设备的支持更好，所以才打算在公开博客里使用它。
生成和更新服务器的命令大致如下,每次写完内容后要做的操作： ``` sh  生成＆更新博客的命令 rake generate   #将source目录下的markdown文本生产为public目录下的blog rake preview    #本地预览 localhost:4000 rake deploy     #根据public目录生成_deploy目录并上传github #上边的操作已经更新了网站服务器，以下是保存代码改动到github服务器的其他branch               git add . git commit -m "comments" git push ```


# how-to 整合

终于到了org与octopress整合的部分了。关于整合 orgmode 和 octopress（jekyll），可以找到几种方式：
org 导出html，直接交给 jekyll 处理。这么做有个问题，org生成的html可能和 markdown 产生的html有差异，有的时候兼容性不好。比如，插入<!--more-->语句时，由于 org 生成的 html 充满了 div ，导致在有 headline 的情况下页面可能会乱掉。
org 文件通过 emacs 的插件转换为 markdown 格式，再由 jekyll 处理。可以到这里找到相关资源。
org-ruby。 通过Ruby将 org 文件转化为 html，而不是通过emacs。
目前为止，我采用的还是第一种方法。


# org mode export 

http://orgmode.org/manual/Exporting.html

参考 [worg](http://orgmode.org/worg/org-tutorials/org-publish-html-tutorial.html)
写出我的发布配置：
(require 'org-publish)
(setq org-publish-project-alist
      '(
        ("blog-notes"
         :base-directory "~/org/blog/"
         :base-extension "org"
         :publishing-directory "~/org/dayigu.github.com/"
         :recursive t
         :publishing-function org-publish-org-to-html
         :headline-levels 4
         :section-numbers nil
         :auto-preamble t
         :auto-sitemap t                ; Generate sitemap.org automagically...
         :sitemap-filename "sitemap.org"  ; ... call it sitemap.org (it's the default)...
         :sitemap-title "Sitemap"         ; ... with title 'Sitemap'.
         :author "dayigu"
         :email "dayigu at gmail dot com"
         :style    "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/worg.css\"/>"
         )
        ("blog-static"
         :base-directory "~/org/blog/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/org/dayigu.github.com/"
         :recursive t
         :publishing-function org-publish-attachment
         )
        ("blog" :components ("blog-notes" "blog-static"))
        ;;
        ))


评论直接采用 disqus, 将 disqus 给出的评论代码设置给 html-postamble 。
写的blog post 都放在 ~/org/blog 下，以 ".org" 为文件后缀，图片放在 img 目录下。运行 M-x org-publish-projects, blog, 生成的 html 文件都输出到 ~/org/dayigu.github.com/ 下。
首先要 建立一个 index, 它会生成 blog 的首页，所有的 post list 也放在这里面。post 的链接形式为：
[[file:WhyUseOrgModeToWriteBlog][为什么用 org-mode 写blog？]］
另外直接偷懒用了 worg 的 css .
发布到 github 上，也就是 add、commit 再 push
git add .
git commit -m 'org blog commit'
git push -u origin master






# org-mode blog tools

http://orgmode.org/worg/org-blog-wiki.html


# 自动化

## 



## 利用jekyll的一些功能，但html部分由org-mode生成

以下.emacs文件的设置有几个要点：
jekyll 本身针对 markdown 转化设计，但实际也支持html。但是org模式导出html时要设置为body-only，只导出html的body的部分，页面head和footer的内容由 jekyll 生成。
最好不要导出目录（TOC）。
base和publishing目录的设置
虽然设置了资源文件的导出，但是我目前实际没有使用，而是直接把图片等资源文件放到source/rc/下。
``` (setq org-publish-project-alist      '(("blog-org"         :base-directory "~/blog/org/"         :publishing-directory "~/blog/source/"         :base-extension "org"         :recursive t         :publishing-function org-publish-org-to-html     :headline-levels 4     :html-extension "html"     :body-only t ;; Only export section between       :table-of-contents nil     )        ("blog-static"         :base-directory "~/blog/org/"         :publishing-directory "~/blog/source/"         :recursive t         :base-extension "css\\|js\\|bmp\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|swf\\|zip\\|gz\\|txt\\|el\\|pl\\|mht\\|log\\|bin_\\|bat\\|tst\\|doc\\|docx\\|gz"         :publishing-function org-publish-attachment     )        ("blog"         :components ("blog-org" "blog-static")         :author "靖天"         ))) ```




## template

http://github.com/capitaomorte/yasnippet

http://github.com/capitaomorte/yasnippet
YASnippet is a template system for Emacs. It allows you to type an abbreviation and automatically expand it into function templates. Bundled language templates includes: C, C++, C#, Perl, Python, Ruby, SQL, LaTeX, HTML, CSS and more. The snippet syntax is inspired from TextMate's syntax, you can even import most TextMate templates to YASnippet. Watch a demo at YouTube.

​Documentation has moved here!!!
Report any issues in github's issue tracker!!!
Discussion continues to be hosted by google yasnippet here
I will keep all the downloads and other stuff here for a while! Thanks google it's been great but it's time to move on!


