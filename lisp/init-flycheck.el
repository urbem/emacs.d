(when (maybe-require-package 'flycheck)
  (add-hook 'after-init-hook 'global-flycheck-mode)
  (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list))




(setq flycheck-flake8-maximum-line-length 100)
(setq flycheck-pylintrc "~/.emacs.d/config/pylintrc")


;; golang lint
(eval-after-load 'flycheck '(add-hook 'flycheck-mode-hook #'flycheck-golangci-lint-setup))

(setq flycheck-golangci-lint-config "/Users/yayu/Golang/src/krobelus/.golangci.yml")


(provide 'init-flycheck)
