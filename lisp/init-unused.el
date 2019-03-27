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


;; fancy-widen
;;(fancy-narrow-mode)


;; smart-compile
(require-package 'smart-compile)
;; smart compile

(add-to-list 'smart-compile-alist '("\\.scala\\'" . "scala -feature -deprecation %f"))
(add-to-list 'smart-compile-alist '("\\.rs\\'" . "rustc %f"))
(add-to-list 'smart-compile-alist '("Cargo\\.toml\\'" . "cargo build"))
(add-to-list 'smart-compile-alist '("\\.py\\'" . "python %f"))
(add-to-list 'smart-compile-alist '("\\.go\\'" . "go run %f"))


;; (defun copy-string ()
;;   "Copy a string in double quote."
;;   (interactive)
;;   (let ((point-start (search-forward "\""))
;;         (point-end (search-forward "\""))
;;         )
;;     (message "start: %s, end:%s" point-start point-end)
;;     (copy-region-as-kill point-start (- point-end 1))
;;     )
;;   )


;; (defun copy-token ()
;;   "Copy a token."
;;   (interactive)
;;   (let ((point-start (point))
;;         (point-end (search-forward " "))
;;         )
;;     (message "length: %d" (- point-end  point-start))
;;     (copy-region-as-kill point-start (- point-end 1))

;;     )
;;   )


;; disable mouse
;; (dolist (k '([mouse-1] [down-mouse-1] [drag-mouse-1] [double-mouse-1] [triple-mouse-1]
;;              [mouse-2] [down-mouse-2] [drag-mouse-2] [double-mouse-2] [triple-mouse-2]
;;              [mouse-3] [down-mouse-3] [drag-mouse-3] [double-mouse-3] [triple-mouse-3]
;;              [mouse-4] [down-mouse-4] [drag-mouse-4] [double-mouse-4] [triple-mouse-4]
;;              [mouse-5] [down-mouse-5] [drag-mouse-5] [double-mouse-5] [triple-mouse-5]))
;;   (global-unset-key k))




(defun toggle-quotes-- ()
  (interactive)
  (save-excursion (let ((start (nth 8 (syntax-ppss)))
                        (quote-length 0) sub kind replacement)
                    (goto-char start)
                    (setq sub
                          (buffer-substring
                           start
                           (progn (forward-sexp)
                                  (point)))
                          kind (aref sub 0))
                    (while (char-equal kind (aref sub 0))
                      (setq sub (substring sub 1) quote-length (1+ quote-length)))
                    (setq sub (substring sub 0 (- (length sub) quote-length)))
                    (goto-char start)
                    (delete-region start (+ start (* 2 quote-length)
                                            (length sub)))
                    (setq kind (if (char-equal kind ?\") ?\' ?\"))
                    (loop for i from 0 for c across sub for slash = (char-equal c ?\\) then (if (and
                                                                                                 (not
                                                                                                  slash)
                                                                                                 (char-equal
                                                                                                  c
                                                                                                  ?\\)) t
                                                                                              nil)
                          do (unless slash (when (member c '(?\" ?\'))
                                             (aset sub i (if (char-equal kind ?\") ?\' ?\")))))
                    (setq replacement (make-string quote-length kind))
                    (insert replacement sub replacement))))




;; sr-speedbar




;; (setq speedbar-frame-parameters '((minibuffer)
;;                                   (width . 25)
;;                                   (border-width . 0)
;;                                   (menu-bar-lines . 0)
;;                                   (tool-bar-lines . 0)
;;                                   (unsplittable . t)
;;                                   (left-fringe . 0)))
;; (setq speedbar-hide-button-brackets-flag t)
;; (setq speedbar-show-unknown-files t)
;; (setq speedbar-smart-directory-expand-flag t)
;; (setq speedbar-use-images nil)
;; (setq sr-speedbar-auto-refresh t)
;; (setq sr-speedbar-max-width 40)
;; (setq sr-speedbar-right-side nil)
;; (setq sr-speedbar-width-console 25)
;; (setq sr-speedbar-width 25)
;; (setq sr-speedbar-skip-other-window-p t)

;; (when window-system
;;   (defadvice sr-speedbar-open (after sr-speedbar-open-resize-frame activate)
;;     (set-frame-width (selected-frame)
;;                      (+ (frame-width) sr-speedbar-width)))
;;   (ad-enable-advice 'sr-speedbar-open 'after 'sr-speedbar-open-resize-frame)
;;   (defadvice sr-speedbar-close (after sr-speedbar-close-resize-frame activate)
;;     (sr-speedbar-recalculate-width)
;;     (set-frame-width (selected-frame)
;;                      (- (frame-width) sr-speedbar-width)))
;;   (ad-enable-advice 'sr-speedbar-close 'after 'sr-speedbar-close-resize-frame))




(provide 'unused)
;;; init-unused.el ends here
