(setq auto-mode-alist (append '(("SConstruct\\'" . python-mode) 
                                ("SConscript\\'" . python-mode)) auto-mode-alist))

(require-package 'pip-requirements)

(when (maybe-require-package 'anaconda-mode) 
  (after-load 'python (add-hook 'python-mode-hook 'anaconda-mode) 
              (add-hook 'python-mode-hook 'anaconda-eldoc-mode)) 
  (when (maybe-require-package 'company-anaconda) 
    (after-load 'company (add-hook 'python-mode-hook 
                                   (lambda () 
                                     (sanityinc/local-push-company-backend 'company-anaconda))))))



(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

(setq py-autopep8-options (quote ("--max-line-length=100")))

;; python test
(require-package 'pytest)
(add-hook 'python-mode-hook 
          (lambda () 
            (local-set-key (kbd "C-c C-t") 'pytest-one)))



(provide 'init-python-mode)
