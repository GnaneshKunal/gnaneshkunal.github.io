(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Install use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;; org mode
(use-package org)

(setq org-id-link-to-org-use-id
      'create-if-interactive-and-no-custom-id)

;; Based on org-expiry-insinuate
(add-hook 'org-insert-heading-hook 'org-id-get-create)
(add-hook 'org-after-todo-state-change-hook 'org-id-get-create)
(add-hook 'org-after-tags-change-hook 'org-id-get-create)

(defun my/org-update-ids ()
  (interactive)
  (let* ((tree (org-element-parse-buffer 'headline))
         (map (reverse
               (org-element-map tree 'headline
                 (lambda (hl)
                   (org-element-property :begin hl))))))
    (save-excursion
      (cl-loop for point in map do
               (goto-char point)
               (org-id-get-create)))))

(setq org-export-html-validation-link nil)
(setq org-export-html-postamble nil)



(setq org-id-link-to-org-use-id
      'create-if-interactive-and-no-custom-id)

;; Based on org-expiry-insinuate
(add-hook 'org-insert-heading-hook 'org-id-get-create)
(add-hook 'org-after-todo-state-change-hook 'org-id-get-create)
(add-hook 'org-after-tags-change-hook 'org-id-get-create)

(defun my/org-update-ids ()
  (interactive)
  (let* ((tree (org-element-parse-buffer 'headline))
         (map (reverse
               (org-element-map tree 'headline
                 (lambda (hl)
                   (org-element-property :begin hl))))))
    (save-excursion
      (cl-loop for point in map do
               (goto-char point)
               (org-id-get-create)))))


(setq org-export-html-validation-link nil)
(setq org-export-html-postamble nil)

(defvar my-org-html-export-theme 'tsdh-light)

(defun my-with-theme (orig-fun &rest args)
  (load-theme my-org-html-export-theme)
  (unwind-protect
      (apply orig-fun args)
    (disable-theme my-org-html-export-theme)))

(with-eval-after-load "ox-html"
  (advice-add 'org-export-to-buffer :around 'my-with-theme))

(require 'ox-publish)

(defun my-site-format-entry (entry style project)
  (when (not (directory-name-p entry))
    (concat
     (format "
%s
[[file:%s][%s]]
"
             (car (split-string (car (org-publish-find-property entry :date project 'html))))
             entry
             (org-publish-find-title entry project)))))


(setq website-html-postamble "<div class=\"footer\"> Copyright 2020 %a.<br> Last updated %C.<br> Built with %c.  </div>")

(setq org-publish-project-alist
      '(("non-posts"
         :base-directory "~/gk/non/"
         :base-extension "org"
         :publishing-directory "~/gk/public/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :html-doctype "html5"
         :html-html5-fancy t
         :html-head "<link rel=\"stylesheet\" href=\"css/stylesheet.css\">"
         :html-head-extra "<link rel=\"stylesheet\" media=\"screen\" href=\"https://fontlibrary.org//face/source-sans-pro\" type=\"text/css\"/><link rel=\"stylesheet\" media=\"screen\" href=\"https://fontlibrary.org//face/source-code-pro\" type=\"text/css\"/><script data-goatcounter=\"https://gnanesh.goatcounter.com/count\" async src=\"//gc.zgo.at/count.js\"></script>"
         :html-postamble "
<hr></hr>
<div class=\"nav\">
<ul>
<li><a href=\"index.html\">Home</a></li>
<li><a href=\"about.html\">About</a></li>
<li><a href=\"https://github.com/Gnaneshkunal\">GitHub</a></li>
<li><a href=\"resume.html\">Résumé</a></li>
<li><a href=\"key.pub\">PGP</a></li>
</ul>
</div>"
         :with-creator t
         :with-date t
         )
        ("posts"
         :base-directory "~/gk/org/"
         :base-extension "org"
         :publishing-directory "~/gk/public/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :auto-sitemap t
         :sitemap-title "Gnanesh's web logs"
         :sitemap-filename "index.org"
         :sitemap-style list
         :author "Gnanesh"
         :email "gnaneshkunal@outlook.com"
         :sitemap-sort-files anti-chronologically
         :sitemap-file-entry-format "%d - %t"
         :sitemap-format-entry my-site-format-entry 

         :html-doctype "html5"
         :html-html5-fancy t
         :html-head "<link rel=\"stylesheet\" href=\"css/stylesheet.css\">"
         :html-head-extra "<link rel=\"stylesheet\" media=\"screen\" href=\"https://fontlibrary.org//face/source-sans-pro\" type=\"text/css\"/><link rel=\"stylesheet\" media=\"screen\" href=\"https://fontlibrary.org//face/source-code-pro\" type=\"text/css\"/><script data-goatcounter=\"https://gnanesh.goatcounter.com/count\" async src=\"//gc.zgo.at/count.js\"></script>"
         :html-postamble "
<hr></hr>
<div class=\"nav\">
<ul>
<li><a href=\"index.html\">Home</a></li>
<li><a href=\"about.html\">About</a></li>
<li><a href=\"https://github.com/Gnaneshkunal\">GitHub</a></li>
<li><a href=\"resume.html\">Résumé</a></li>
<li><a href=\"key.pub\">PGP</a></li>
</ul>
</div>
"
         :with-creator t
         :with-date t
         )
        ("css"
          :base-directory "~/gk/css/"
          :base-extension "css"
          :publishing-directory "~/gk/public/css"
          :publishing-function org-publish-attachment
          :recursive t)
        ("img"
          :base-directory "~/gk/img/"
          :base-extension "jpg\\|gif\\|png\\|svg"
          :publishing-directory "~/gk/public/img"
          :publishing-function org-publish-attachment
          :recursive t)
        ("static"
         :base-directory "~/gk/non/"
         :base-extension "pdf\\|pub"
         :publishing-directory "~/gk/public/"
         :publishing-function org-publish-attachment
         :recursive t
         )
        ("all" :components ("posts" "css" "img" "non-posts" "static"))))

(use-package scala-mode
  :ensure t)

(use-package htmlize
  :ensure t)
