;;; init-packages -- install some useful packages
;;; Commentary:
;; Copyright (C) 2017  Hang Yan
;; Author: Hang Yan <hangyan@hotmail.com>

;;; Code:

(require-package 'dash)
(eval-after-load 'dash '(dash-enable-font-lock))


;;-map
;; 'require-package
;; '(wgrep project-local-variables diminish scratch mwe-log-commands ecb py-autopep8 s icicles))

(defun packages-install (packages)
  (--each
      packages
    (when (not (package-installed-p it))
      (package-install it)))
  (delete-other-windows))



(defun init--install-packages ()
  "Install some packages."
  (packages-install '(magit edn inflections hydra paredit move-text gist htmlize smart-compile
                            visual-regexp markdown-mode fill-column-indicator flycheck
                            flycheck-pos-tip flycheck-clojure flx f flx-ido dired-details css-eldoc
                            yasnippet smartparens ido-vertical-mode ido-at-point simple-httpd
                            guide-key  highlight-escape-sequences whitespace-cleanup-mode
                            elisp-slime-nav dockerfile-mode clojure-mode
                            clojure-mode-extra-font-locking groovy-mode prodigy cider yesql-ghosts
                            string-edit go-autocomplete go-mode helm ecb restclient
                            company-restclient )))

(condition-case nil (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))



(provide 'init-packages)
;;; init-packages.el ends here
