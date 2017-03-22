(when (maybe-require-package 'flycheck)
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list))



;; spell
;;(add-hook 'text-mode-hook 'flyspell-mode)
;;(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(setq flycheck-flake8-maximum-line-length 100)



(provide 'init-flycheck)
