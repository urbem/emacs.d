;;; init-helm.el --- helm                            -*- lexical-binding: t; -*-

;; Copyright (C) 2017  yayu

;; Author: yayu <yayu@bogon>
;; Keywords: abbrev


;;; Code:

(require-package 'helm)
(require 'helm-config)
(helm-mode 1)


(helm-autoresize-mode t)
;; (setq helm-M-x-fuzzy-match t)

;; (global-set-key (kbd "M-x") 'helm-M-x)
;; (global-set-key (kbd "M-y") 'helm-show-kill-ring)
;; (global-set-key (kbd "C-x b") 'helm-mini)

;; (setq helm-buffers-fuzzy-matching t
;;       helm-recentf-fuzzy-match    t)

(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)




(provide 'init-helm)
;;; init-helm.el ends here
