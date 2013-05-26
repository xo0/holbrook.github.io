---
layout: index
---

{% for page in site.posts limit:10 %}
<div class="white-panel">
  <div class="single-post">
        <h4><a href="{{page.url}}">{{page.title}}</a></h4>
        <p class="pre-meta">
           {{ page.date|date:"%Y-%m-%d" }} &sdot; 分类：aaa &sdot; 标签： aaa bbb ccc ddd
        </p>
        <p>{{ page.description }}</p>
        <a href="{{page.url}}" class="btn btn-primary">阅读全文&rarr;</a>
  </div>
</div>
{% endfor %}


<a href="/archive.html">查看所有{{site.posts.size}}篇文章...</a>


<div class="sidebar-title">文章分类</div>
        <div>
            <ul class="tag_box inline">
            {% assign categories_list = site.categories %}
            {% include JB/categories_list %}
            </ul>
        </div>
        <br>
        <div class="sidebar-title">标签</div>
        <div>
            <ul class="tag_box inline">
            {% assign tags_list = site.tags %}  
            {% include JB/tags_list %}
            </ul>
        </div>

