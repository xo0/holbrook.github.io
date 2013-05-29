---
layout: index
---

{% for page in site.posts limit:10 %}
<div class="white-panel">
  <div class="single-post">
        <h4><a href="{{page.url}}">{{page.title}}</a></h4>
        <p class="pre-meta">
           {% include post_info_bar %}
        </p>
        <p>{{ page.description }}</p>
        <a href="{{page.url}}" class="btn btn-primary">阅读全文&rarr;</a>
  </div>
</div>
{% endfor %}

<div class="row">
<a href="/archive.html">查看所有{{site.posts.size}}篇文章...</a>
</div>



