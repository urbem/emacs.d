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
  "Find all match for `REGEX' within `STR', returning the full match string or group `GROUP'."
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

(eval-after-load "webjump" '(add-to-list 'webjump-sites '("Python" . [simple-query
                                                                      "https://docs.python.org/2.7/"
                                                                      "https://docs.python.org/2.7/search.html?check_keywords=yes&area=default&q="
                                                                      ""])))


;; remove lock files
(setq create-lockfiles nil)


;; disable it ....
(setq make-backup-files nil)
(setq auto-save-default nil)


(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)



;; helpful
;; Note that the built-in `describe-function' includes both functions
;; and macros. `helpful-function' is functions only, so we provide
;; `helpful-callable' as a drop-in replacement.
(global-set-key (kbd "C-h f") #'helpful-callable)

(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)



;;; init writer mode
(add-auto-mode 'olivetti-mode ".*\\.write$")


(provide 'init-utils)
