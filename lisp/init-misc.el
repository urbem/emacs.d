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


(add-auto-mode 'restclient-mode ".*\\.http$")

(add-hook 'restclient-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 '(company-restclient))
            (company-mode)))


(require 'any-ini-mode)
(add-auto-mode 'any-ini-mode ".*\\.ini$")
(add-auto-mode 'any-ini-mode ".*\\.conf$")
(add-auto-mode 'any-ini-mode ".*pylintrc$")


;; auto format shell script when save
(defun my-shell-mode-auto-format-hook ()
  "Add auto format for shell mode."
  (when (eq major-mode 'sh-mode)
    (setq f (buffer-file-name))
    (shell-command (format "shfmt -i 4 -w %s" f))))

(add-hook 'after-save-hook #'my-shell-mode-auto-format-hook)


(defun load-raml-mode ()
  "Load raml mode."
  (interactive)
  (load-file "~/.emacs.d/site-lisp/modes/raml-mode.el")
  (raml-mode))


;; dockerfile mode lint
;;(require 'flycheck-hadolint)


(require-package 'restart-emacs)

(provide 'init-misc)
