;;;(load-file "./ox-html.el")  
;;;(load-file "./ox-rss.el")  
;;; orgblog-publisher nothing

(add-to-list 'load-path "~/.emacs.d/site-lisp/org-jekyll-mode")
(require 'org-jekyll-mode)

(require 'org-publish)
;;;(require 'ox-rss)

(setq org-publish-project-alist
      '(
        ;; These are the main web files
        ("org-notes"
         :base-directory "./src/" ;; Change this to your local dir
         :base-extension "org"
         :publishing-directory "./output/"
;;         :body-only t
         :recursive t
         :publishing-function org-publish-org-to-html
;;         :publishing-function org-jekyll-export-to-html
;;         :link-home "index.html"
;;         :link-up "sitemap.html"
         :html-link-home "index.html"
         :html-link-up "sitemap.html"

         :headline-levels 4       ; Just the default for this project.
         :section-numbers nil
         :auto-preamble t
         :auto-sitemap t                ; Generate sitemap.org automagically...
         :sitemap-filename "sitemap.org"  ; ... call it sitemap.org (it's the default)...
         :sitemap-title "Sitemap"         ; ... with title 'Sitemap'.

         :author "Holbrook"
         :email "wanghaikuo@gmail.com"
;;         :style    "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/main.css\"/>"
         :html-head  "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/main.css\"/>"
         :html-head-extra
         "<link rel=\"alternate\" type=\"application/rss+xml\"
                href=\"http://mydomain.org/my-blog.xml\"
                title=\"RSS feed for mydomain.org\">"

         :html-preamble "可以添加博客的头部"
         :html-postamble " 评论系统代码(disqus,多说等等)
      <p class=\"author\">Author: %a (%e)</p><p>Last Updated %d . Created by %c </p>"


;;         :section-numbers nil
;;         :table-of-contents t
;;         :style-include-default nil
         )




       ;; (     "blog-rss"
        ;;         :base-directory "./posts/"
        ;;         :base-extension "org"
        ;;       :publishing-directory "~/public_html/"
        ;;     :publishing-function (org-rss-publish-to-rss)
        ;;   :html-link-home "http://mydomain.org/"
        ;; :html-link-use-abs-url t)
        


        ;; These are static files (images, pdf, etc)
        ("post-static"
         :base-directory "./src/" ;; Change this to your local dir
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|txt\\|asc"
         :publishing-directory "./output/images/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ;; These are static files (images, pdf, etc)
        ("blog-static"
         :base-directory "./site/" ;; Change this to your local dir
         :base-extension ".*"
         :publishing-directory "./output/"

         :recursive t
         :publishing-function org-publish-attachment
         )

        ("org" :components ("org-notes" "org-static"))
        )
      )

(defun myweb-publish nil
  "Publish myweb."
  (interactive)
  (org-publish-all))

(myweb-publish)

