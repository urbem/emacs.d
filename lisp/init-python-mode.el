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




;; ugly hack to disable flake8 checks if flake8 not working well
(defun process-exit-code-and-output (program &rest args) 
  "Run PROGRAM with ARGS and return the exit code and output in a list."
  (with-temp-buffer (list (apply 'call-process program nil (current-buffer) nil args) 
                          (buffer-string))))

(with-eval-after-load 'flycheck (when (> (car (process-exit-code-and-output "flake8")) 0) 
                                  (setq-default flycheck-disabled-checkers '(python-flake8))))



(defun venv-checkout-if-exist () 
  "Use virtualenv if present." 
  (interactive) 
  (let ((venvs (venv-get-candidates)) 
        (target-env-name (projectile-project-name))) 
    (if (member target-env-name venvs) 
        (progn (venv-deactivate) 
               (venv-workon target-env-name) 
               (setq venv-current-name target-env-name) 
               (message "Checkout virtualenv: %s" target-env-name)) 
      (progn (when (not (string= target-env-name "-")) 
               (message "No virtualenv found for project: [%s]!" target-env-name))))))


(defun venv-create-for-project () 
  "Create virtualenv for this project." 
  (interactive) 
  (let ((target-env-name (projectile-project-name))) 
    (let ((cmd (concat "virtualenv --system-site-packages ~/.virtualenvs/" target-env-name))) 
      (message "Running command: %s" cmd) 
      (shell-command (concat cmd " &")))))

(defun venv-install-package (package-name) 
  "Install a python package who's name is PACKAGE-NAME." 
  (interactive "sPackage name:") 
  (let ((venv-dir (concat "~/.virtualenvs/" (projectile-project-name)))) 
    (shell-command (concat (concat (concat (concat "source " venv-dir)
                                           "/bin/activate && pip install ") package-name) " &"))))



(add-hook 'python-mode-hook 
          (lambda () 
            (local-set-key (kbd "C-c C-t") 'pytest-one) 
            (local-set-key (kbd "C-c g i") 'py-goto-imports) 
            (venv-checkout-if-exist)))


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
