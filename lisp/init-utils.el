(if (fboundp 'with-eval-after-load) 
    (defalias 'after-load 'with-eval-after-load) 
  (defmacro after-load (feature &rest body) 
    "After FEATURE is loaded, evaluate BODY."
    (declare (indent defun)) 
    `(eval-after-load ,feature '(progn ,@body))))


;;----------------------------------------------------------------------------
;; Handier way to add modes to auto-mode-alist
;;----------------------------------------------------------------------------
(defun add-auto-mode (mode &rest patterns) 
  "Add entries to `auto-mode-alist' to use `MODE' for all given file `PATTERNS'."
  (dolist (pattern patterns) 
    (add-to-list 'auto-mode-alist (cons pattern mode))))


;;----------------------------------------------------------------------------
;; String utilities missing from core emacs
;;----------------------------------------------------------------------------
(defun sanityinc/string-all-matches (regex str &optional group) 
  "Find all matches for `REGEX' within `STR', returning the full match string or group `GROUP'."
  (let ((result nil) 
        (pos 0) 
        (group (or group 
                   0))) 
    (while (string-match regex str pos) 
      (push (match-string group str) result) 
      (setq pos (match-end group))) result))


;;----------------------------------------------------------------------------
;; Delete the current file
;;----------------------------------------------------------------------------
(defun delete-this-file () 
  "Delete the current file, and kill the buffer." 
  (interactive) 
  (or (buffer-file-name) 
      (error 
       "No file is currently being edited")) 
  (when (yes-or-no-p (format "Really delete '%s'?" (file-name-nondirectory buffer-file-name))) 
    (delete-file (buffer-file-name)) 
    (kill-this-buffer)))


;;----------------------------------------------------------------------------
;; Rename the current file
;;----------------------------------------------------------------------------
(defun rename-this-file-and-buffer (new-name) 
  "Renames both current buffer and file it's visiting to NEW-NAME." 
  (interactive "sNew name: ") 
  (let ((name (buffer-name)) 
        (filename (buffer-file-name))) 
    (unless filename 
      (error 
       "Buffer '%s' is not visiting a file!"
       name)) 
    (progn (when (file-exists-p filename) 
             (rename-file filename new-name 1)) 
           (set-visited-file-name new-name) 
           (rename-buffer new-name))))

;;----------------------------------------------------------------------------
;; Browse current HTML file
;;----------------------------------------------------------------------------
(defun browse-current-file () 
  "Open the current file as a URL using `browse-url'." 
  (interactive) 
  (let ((file-name (buffer-file-name))) 
    (if (and (fboundp 'tramp-tramp-file-p) 
             (tramp-tramp-file-p file-name)) 
        (error 
         "Cannot open tramp file") 
      (browse-url (concat "file://" file-name)))))


(defun save-as-script () 
  "Set script exec mode on save."
  (and (save-excursion (save-restriction (widen) 
                                         (goto-char (point-min)) 
                                         (save-match-data (looking-at "^#!")))) 
       (not (file-executable-p buffer-file-name)) 
       (shell-command (concat "chmod u+x " (shell-quote-argument buffer-file-name))) 
       (message (concat "Saved as script: " buffer-file-name))))


;; Making scripts executable on save
(add-hook 'after-save-hook #'save-as-script)


;; web jump

(global-set-key (kbd "C-x j") 'webjump)

;; Add Urban Dictionary to webjump
(eval-after-load "webjump" '(add-to-list 'webjump-sites '("Urban Dictionary" . [simple-query
                                                                                "www.urbandictionary.com"
                                                                                "http://www.urbandictionary.com/define.php?term="
                                                                                ""])))



(defun delete-current-buffer-file () 
  "Removes file connected to current buffer and kills buffer." 
  (interactive) 
  (let ((filename (buffer-file-name)) 
        (buffer (current-buffer)) 
        (name (buffer-name))) 
    (if (not (and filename 
                  (file-exists-p filename))) 
        (ido-kill-buffer) 
      (when (yes-or-no-p "Are you sure you want to remove this file? ") 
        (delete-file filename) 
        (kill-buffer buffer) 
        (message "File '%s' successfully removed" filename)))))

(defun delete-current-buffer-file () 
  "Removes file connected to current buffer and kills buffer." 
  (interactive) 
  (let ((filename (buffer-file-name)) 
        (buffer (current-buffer)) 
        (name (buffer-name))) 
    (if (not (and filename 
                  (file-exists-p filename))) 
        (ido-kill-buffer) 
      (when (yes-or-no-p "Are you sure you want to remove this file? ") 
        (delete-file filename) 
        (kill-buffer buffer) 
        (message "File '%s' successfully removed" filename)))))

(global-set-key (kbd "C-x C-k") 'delete-current-buffer-file)




;; remove lock files
(setq create-lockfiles nil)



;; template files
;; template
(auto-insert-mode)
(setq auto-insert-directory "~/.emacs.d/templates/") ;; trailing slash IMPORTANT
(define-auto-insert "\.py" "python-template.py")
(setq auto-insert-query nil)


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


(require 'cl)
(defun bk-kill-buffers (regexp) 
  "Kill buffers matching REGEXP without asking for confirmation." 
  (interactive "sKill buffers matching this regular expression: ") 
  (cl-flet 
      ((kill-buffer-ask (buffer) 
                        (kill-buffer buffer))) 
    (kill-matching-buffers regexp)))

(add-hook 'tempbuf-mode-hook 
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


;; auto save
;;(require-package 'real-auto-save)
;;(add-hook 'prog-mode-hook 'real-auto-save-mode)



(provide 'init-utils)
