---
layout: page
title: 目录
header: 按目录浏览
group: navigation
---


<ul class="tag_box inline">
  {% assign categories_list = site.categories %}
  {% if categories_list.first[0] == null %}
    {% for category in categories_list %} 
    	<li><a href="{{ BASE_PATH }}{{ site.JB.categories_path }}#{{ category }}-ref" rel="category">
    		{{ category | join: "/" }} <span>{{ site.categories[category].size }}</span>
    	</a></li>
    {% endfor %}
  {% else %}
    {% for category in categories_list %} 
    	<li><a href="{{ BASE_PATH }}{{ site.JB.categories_path }}#{{ category[0] }}-ref" rel="category">
    		{{ category[0] | join: "/" }} <span>{{ category[1].size }}</span>
    	</a></li>
    {% endfor %}
  {% endif %}
  {% assign categories_list = nil %}
</ul>


{% for category in site.categories %} 
  <h2 id="{{ category[0] }}-ref">{{ category[0] | join: "/" }}</h2>
  <ul>
    {% assign pages_list = category[1] %}  
    {% include pages_list %}
  </ul>
{% endfor %}

