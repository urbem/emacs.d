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

;; sort imports
(defun my-python-mode-before-save-hook () 
  "Sort imports before save."
  (when (eq major-mode 'python-mode) 
    (py-isort-buffer)))
(add-hook 'before-save-hook #'my-python-mode-before-save-hook)

;; python got to import section
(defun py-goto-imports () 
  "Move point to the block of imports.
Since we will sort the imports before
save, so we it's ok to move to the first import line." 
  (interactive) 
  (let ((old-point (point))) 
    (goto-char (point-min)) 
    (push-mark old-point) 
    (if (re-search-forward "^import" nil t) 
        (move-beginning-of-line 1) 
      (goto-char old-point))))



;; python test
(require-package 'pytest)
(add-hook 'python-mode-hook 
          (lambda () 
            (local-set-key (kbd "C-c C-t") 'pytest-one) 
            (local-set-key (kbd "C-c g i") 'py-goto-imports) 
            (venv-workon (projectile-project-name))))


;; virtualenv
(require-package 'virtualenvwrapper)
(venv-initialize-interactive-shells)
(venv-initialize-eshell)

(setq projectile-switch-project-action 
      '(lambda () 
         (venv-projectile-auto-workon) 
         (projectile-find-file)))

(setq-default mode-line-format (cons 
                                '(:exec venv-current-name)
                                mode-line-format))








(provide 'init-python-mode)
