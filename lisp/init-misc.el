;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------
(add-auto-mode 'tcl-mode "Portfile\\'")
(fset 'yes-or-no-p 'y-or-n-p)

(when (fboundp 'prog-mode)
  (add-hook 'prog-mode-hook 'goto-address-prog-mode))
(setq goto-address-mail-face 'link)

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(setq-default regex-tool-backend 'perl)

(add-auto-mode 'conf-mode "Procfile")



;; ini mode
(require 'any-ini-mode)
(add-to-list 'auto-mode-alist '(".*\\.ini$" . any-ini-mode))
(add-to-list 'auto-mode-alist '(".*\\.conf$" . any-ini-mode))


;; auto format shell script when save
(defun my-shell-mode-auto-format-hook ()
  "Add auto format for shell mode."
  (when (eq major-mode 'sh-mode)
    (setq f (buffer-file-name))
    (shell-command (format "shfmt -w %s" f))))

(add-hook 'after-save-hook #'my-shell-mode-auto-format-hook)



;; dockerfile mode lint
;;(require 'flycheck-hadolint)


(require-package 'restart-emacs)

(provide 'init-misc)
