;; disable auto-save

(setq make-backup-files nil)

(setq org-clock-persist-file "~/.emacs.d/data/org-clock-save.el")

(setq auto-save-interval 20)
(setq auto-save-visited-file-name t)
(set-face-attribute 'region nil :background "#F0F")

(setq bookmark-save-flag 1)

(setq find-function-C-source-directory "~/Projects/emacs-25.1/src/")

(provide 'init-vars)
