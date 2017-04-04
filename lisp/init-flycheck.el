(when (maybe-require-package 'flycheck)
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list))




(setq flycheck-flake8-maximum-line-length 100)
(setq flycheck-pylintrc "~/.emacs.d/config/pylintrc")


(provide 'init-flycheck)
