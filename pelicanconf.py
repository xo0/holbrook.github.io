#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Holbrook'
SITENAME = u'心内求法'
SITEURL = ''

PATH = 'content'

TIMEZONE = 'Asia/Shanghai'
DATE_FORMATS = {
    'en': ('en_US','%a, %d %b %Y'),
    'cn': ('zh_CN','%Y-%m-%d'),
}

DEFAULT_DATE_FORMAT = '%Y-%m-%d'

MARKUP = ('md', 'ipynb')
#PLUGIN_PATHS = ['./plugins']
PLUGIN_PATH = './plugins'

PLUGINS = ['tag_cloud','pelican-ipynb.markup']


#使用目录名作为文章的分类名
#USE_FOLDER_AS_CATEGORY = True

#使用文件名作为文章或页面的slug（url）
FILENAME_METADATA = '(?P<slug>.*)'

ARTICLE_URL = '{date:%Y}/{date:%m}/{date:%d}/{slug}.html'
ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{date:%d}/{slug}.html'

TAG_URL = ('tag/{slug}.html')     #The URL to use for a tag.
TAG_SAVE_AS = ('tag/{slug}.html')  #The location to save the tag page.



THEME = 'themes/foundation-default-colours'
#THEME = 'themes/pelican-alchemy/alchemy'
DEFAULT_LANG = 'zh'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'),
         ('You can modify those links in your config file', '#'),)

# Social widget
SOCIAL = (('You can add links in your config file', '#'),
          ('Another social link', '#'),)

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

MONTH_ARCHIVE_SAVE_AS = '{date:%Y}/{date:%m}/index.html'
FOUNDATION_FRONT_PAGE_FULL_ARTICLES = False
FOUNDATION_ALTERNATE_FONTS = False
FOUNDATION_TAGS_IN_MOBILE_SIDEBAR = False
FOUNDATION_NEW_ANALYTICS = False
FOUNDATION_ANALYTICS_DOMAIN = ''
FOUNDATION_FOOTER_TEXT = 'Powered by <a href="http://getpelican.com">Pelican</a> and <a href="http://foundation.zurb.com/">Zurb Foundation</a>. Theme by <a href="http://hamaluik.com">Kenton Hamaluik</a>.'
# FOUNDATION_PYGMENT_THEME = 'monokai'

FOUNDATION_PYGMENT_THEME = 'friendly'

