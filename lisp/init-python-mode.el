(setq auto-mode-alist (append '(("SConstruct\\'" . python-mode) 
                                ("SConscript\\'" . python-mode)) auto-mode-alist))

(require-package 'pip-requirements)
(require-package 'py-isort)
(require-package 'pytest)
(require-package 'importmagic)
(require-package 'pyimport)
(require-package 'pydoc)

;; anaconda for code jump and completion
(when (maybe-require-package 'anaconda-mode) 
  (after-load 'python (add-hook 'python-mode-hook 'anaconda-mode) 
              (add-hook 'python-mode-hook 'anaconda-eldoc-mode)) 
  (when (maybe-require-package 'company-anaconda) 
    (after-load 'company (add-hook 'python-mode-hook 
                                   (lambda () 
                                     (sanityinc/local-push-company-backend 'company-anaconda))))))


;; auto pep8 on save

(setq py-autopep8-options (quote ("--max-line-length=100")))
;; auto resolve import for python symbols
(add-to-list 'helm-boring-buffer-regexp-list "\\*epc con")



(defun enable-my-python-or-not () 
  "Only python file in my home dir need the hooks."
  (eq t (and (s-starts-with?  (concat "/Users/" (user-login-name)) 
                              (buffer-file-name)) 
             (eq major-mode 'python-mode))))


(defun my-python-mode-hook () 
  "My python mode hook."
  (when (enable-my-python-or-not) 
    (py-autopep8-enable-on-save) 
    (importmagic-mode)))

(add-hook 'python-mode-hook #'my-python-mode-hook)


;; sort imports
(defun my-python-mode-before-save-hook () 
  "Sort imports before save."
  (when (enable-my-python-or-not) 
    (py-isort-buffer)))
(add-hook 'before-save-hook #'my-python-mode-before-save-hook)




;; virtualenv
(require-package 'virtualenvwrapper)
(venv-initialize-interactive-shells)
(venv-initialize-eshell)


(setq-default mode-line-format (cons 
                                '(:exec venv-current-name)
                                mode-line-format))

;; documents


(defun open-python-doc () 
  "Open doc in default browser." 
  (interactive) 
  (setq word (thing-at-point 'word 'no-properties)) 
  (setq url (format "https://docs.python.org/2/library/%s.html" word)) 
  (with-temp-buffer (shell-command (format "open %s &" url) t)))



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
    (when (member target-env-name venvs) 
      (progn (venv-deactivate) 
             (venv-workon target-env-name) 
             (setq venv-current-name target-env-name) 
             (message "Checkout virtualenv: %s" target-env-name)))))




(defun venv-create-for-project () 
  "Create virtualenv for this project." 
  (interactive) 
  (let ((target-env-name (projectile-project-name))) 
    (let ((cmd (concat "virtualenv --system-site-packages ~/.virtualenvs/" target-env-name))) 
      (message "Running command: %s" cmd) 
      (shell-command (concat cmd " &")))))




;; dumb search
(defun py-dumb-find () 
  "Dumb search in virtualenv." 
  (interactive) 
  (let ((word) 
        (dir)) 
    (setq word (thing-at-point 'word 'no-properties)) 
    (setq dir (concat (concat "~/.virtualenvs/" (projectile-project-name))
                      "/lib/python2.7/site-packages/")) 
    (setq output (shell-command-to-string (format
                                           "grep -r --include='*.py' -nw %s -R %s | egrep ^'defun|class' &"
                                           word dir))) 
    (setq dest (split-string output ":")) 
    (find-file-read-only (car dest)) 
    (goto-line (string-to-number (car (cdr dest))))))





(defun venv-install-package (package-name) 
  "Install a python package who's name is PACKAGE-NAME." 
  (interactive "sPackage name:") 
  (let ((venv-dir (concat "~/.virtualenvs/" (projectile-project-name)))) 
    (shell-command (concat (concat (concat (concat "source " venv-dir)
                                           "/bin/activate && pip install ") package-name) " &"))))


(defun venv-install-requirements () 
  "Install packages in the current requirements file." 
  (interactive) 
  (let ((venv-dir (concat "~/.virtualenvs/" (projectile-project-name)))) 
    (shell-command (concat (concat (concat (concat "source " venv-dir)
                                           "/bin/activate && pip install -r ") 
                                   (buffer-file-name)) " &"))))



(add-hook 'python-mode-hook 
          (lambda () 
            (local-set-key (kbd "C-c C-t") 'pytest-one) 
            (local-set-key (kbd "C-c C-f") 'py-dumb-find) 
            (local-set-key (kbd "C-c C-g") 'py-goto-imports) 
            (local-set-key (kbd "C-c C-d") 'pydoc-at-point) 
            (local-set-key (kbd "C-c C-b") 'open-python-doc) 
            (venv-checkout-if-exist)))






(provide 'init-python-mode)
