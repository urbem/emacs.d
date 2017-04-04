;;; unused -- not to use
;;; Commentary:
;; Copyright (C) 2017  Hang Yan
;; Author: Hang Yan <hangyan@hotmail.com>

;;; Code:



;; tempbuf
(when
    (require 'tempbuf nil 'noerror)
  (add-hook 'custom-mode-hook 'turn-on-tempbuf-mode)
  (add-hook 'w3-mode-hook 'turn-on-tempbuf-mode)
  (add-hook 'Man-mode-hook 'turn-on-tempbuf-mode)
  (add-hook 'compilation-mode-hook 'turn-on-tempbuf-mode)
  (add-hook 'help-mode-hook 'turn-on-tempbuf-mode)
  (add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)
  (add-hook 'view-mode-hook 'turn-on-tempbuf-mode))



;; auto save
;;(require-package 'real-auto-save)
;;(add-hook 'prog-mode-hook 'real-auto-save-mode)




;; venv improvement: unset variable, and deactivate maybe?

;; (add-hook 'switch-buffer-functions
;;           (lambda (pre cur)
;;             (message "%S -> %S" pre cur)))

(setq projectile-switch-project-action
      '(lambda ()
         (venv-projectile-auto-workon)
         (projectile-find-file)))



;; buffer clean
(require-package 'midnight)
(midnight-mode)
(midnight-delay-set 'midnight-delay "4:30am")
(setq midnight-period 10)
(setq clean-buffer-list-kill-regexps '("\\*[Hh]elm.*\\*" "\\*Help\\*" "\\*Customize.*\\*"
                                       "\\*Flycheck.*messages\\*"))

(require 'cl)
(defun bk-kill-buffers (regexp)
  "Kill buffers matching REGEXP without asking for confirmation."
  (interactive "sKill buffers matching this regular expression: ")
  (cl-flet
      ((kill-buffer-ask (buffer)
                        (kill-buffer buffer)))
    (kill-matching-buffers regexp)))

(add-hook 'midnight-hook
          (lambda ()
            (bk-kill-buffers "\\*[Hh]elm.*\\*")
            (bk-kill-buffers "\\*Compile-Log\\*")
            (bk-kill-buffers "\\*WoMan-Log\\*")
            (bk-kill-buffers "\\*markdown-output\\*")
            (bk-kill-buffers "\\*Flycheck-error-messages\\*")
            (bk-kill-buffers "\\*Shell.*Command.*Output.*\*")
            (bk-kill-buffers "\\*clang-output\\*")
            (bk-kill-buffers "\\*clang-error\\*")
            (bk-kill-buffers "tetris-scores")
            (bk-kill-buffers "\\*Tetris\\*")
            (bk-kill-buffers "\\*cscope.*\\*")))




(require-package 'doom-themes)
(load-theme 'doom-one t) ;; or doom-dark, etc.

;;; Settings (defaults)
(setq doom-enable-bold t    ; if nil, bolding are universally disabled
      doom-enable-italic t  ; if nil, italics are universally disabled

      ;; doom-one specific settings
      doom-one-brighter-modeline nil doom-one-brighter-comments nil)

;;; OPTIONAL
;; brighter source buffers (that represent files)
(add-hook 'find-file-hook 'doom-buffer-mode-maybe)
;; if you use auto-revert-mode
(add-hook 'after-revert-hook 'doom-buffer-mode-maybe)
;; you can brighten other buffers (unconditionally) with:
(add-hook 'ediff-prepare-buffer-hook 'doom-buffer-mode)

;; brighter minibuffer when active
;;(add-hook 'minibuffer-setup-hook 'doom-brighten-minibuffer)

;; Enable custom neotree theme
(require 'doom-neotree)       ; all-the-icons fonts must be installed!

;; Enable nlinum line highlighting
(require 'doom-nlinum)              ; requires nlinum and hl-line-mode




(add-hook 'python-mode-hook
          (lambda ()
            (require-package 'sphinx-doc)
            (sphinx-doc-mode t)))




(defun save-buffer-if-visiting-file
    (&optional
     args)
  "Save the current buffer only if it is visiting a file"
  (interactive)
  (if (and (buffer-file-name)
           (buffer-modified-p))
      (save-buffer args)))

;;(add-hook 'auto-save-hook 'save-buffer-if-visiting-file)


;;(setq temporary-file-directory "/tmp/emacs")
;;(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
;;(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))
;;(setq auto-save-timeout 20)

;;(setq auto-save-interval 100)



(provide 'unused)
;;; init-unused.el ends here
