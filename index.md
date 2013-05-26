---
layout: index
---

{% for page in site.posts %}
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

