;;; Publish org website --- summary

(require 'package)
(package-initialize)
(setq package-archives '(("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-refresh-contents)
(dolist (pkg '(htmlize))
  (unless (package-installed-p pkg)
    (package-install pkg)))

(unless (package-installed-p 'ox-rss)
  (package-refresh-contents)
  (package-install 'ox-rss))

(unless (package-installed-p 'dash)
  (package-refresh-contents)
  (package-install 'dash))

(require 'dash)
(require 'org)
(require 'ox-rss)
(require 'ox-publish)

; Project definition
(defvar lc--publish-project-alist
  (list
   ;; generates the main site, and as side-effect, the sitemap for the latest 5 posts
   (list "tutorials"
         :base-directory "./docs/content/"
         :base-extension "org"
         :recursive t
         :publishing-directory "./public/"
         :publishing-function 'org-html-publish-to-html
         :section-numbers nil
         :with-toc t)

   (list "assets"
         :base-directory "./"
         :exclude (regexp-opt '("assets" "public"))
         :include '("./docs/CNAME" "./docs/LICENSE" "./docs/publish.el" "./neuroflame.jpeg")
         :recursive t
         :base-extension (regexp-opt '("jpeg" "gif" "png" "js" "svg" "css" "pdf"))
         :publishing-directory "./public"
         :publishing-function 'org-publish-attachment)))

(defun lc-publish-all ()
  "Publish the blog to HTML."
  (interactive)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((dot . t) (plantuml . t)))
  (let ((make-backup-files nil)
        (org-publish-project-alist lc--publish-project-alist)
        ;; deactivate cache as it does not take the publish.el file into account
        (user-full-name "Alexandre Mahrach")
        (user-mail-address "mahrachalexandre@gmail.com")
        (org-src-fontify-natively t)
        (org-publish-cache nil)
        (org-publish-use-timestamps-flag nil)
        (org-export-with-section-numbers nil)
        (org-export-with-smart-quotes    t)
        (org-export-with-toc nil)
        (org-export-with-sub-superscripts '{})
        (org-html-divs '((preamble  "header" "preamble")
                         (content   "main"   "content")
                         (postamble "footer" "postamble")))
        (org-html-container-element         "section")
        (org-html-metadata-timestamp-format "%d %b. %Y")
        (org-html-checkbox-type 'html)
        (org-html-html5-fancy t)
        (org-html-validation-link nil)
        (org-html-doctype "html5")
        (org-html-htmlize-output-type       'css)
        (org-plantuml-jar-path (-first 'file-exists-p
                                       '("/usr/share/java/plantuml.jar" "/usr/share/plantuml/plantuml.jar")))
        (org-confirm-babel-evaluate
         (lambda (lang body)
           (message (format "in lambda %s" lang))
           (not (member lang '("dot" "plantuml"))))))
    (org-publish-all)))

(provide 'publish)
;;; publish.el ends here
