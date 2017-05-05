;;; init-func.el


;;; Code:


(defun delete-current-buffer-file ()
  "Remove file connected to current buffer and kill buffer."
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


(defun kill-some-buffer (buffer)
  "Ignore some BUFFER."
  (if (member (buffer-name buffer)
              '("*Messages*" "*anaconda-mode*"))
      (message "Ignore you : %s" (buffer-name buffer))
    (kill-buffer buffer)))


(defun only-current-buffer ()
  "Kill other buffers."
  (interactive)
  (mapc 'kill-some-buffer (cdr (buffer-list (current-buffer)))))



(defun recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file (find-file file))))



(defun ido-imenu ()
  "Update the imenu index and then use ido to select a symbol to navigate to.
Symbols matching the text at point are put first in the completion list."
  (interactive)
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (cl-flet
        ((addsymbols (symbol-list)
                     (when (listp symbol-list)
                       (dolist (symbol symbol-list)
                         (let ((name nil)
                               (position nil))
                           (cond ((and
                                   (listp symbol)
                                   (imenu--subalist-p symbol))
                                  (addsymbols symbol))
                                 ((listp symbol)
                                  (setq name (car symbol))
                                  (setq position (cdr symbol)))
                                 ((stringp symbol)
                                  (setq name symbol)
                                  (setq position (get-text-property 1 'org-imenu-marker symbol))))
                           (unless (or (null position)
                                       (null name))
                             (add-to-list 'symbol-names name)
                             (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist))
    ;; If there are matching symbols at point, put them at the beginning of `symbol-names'.
    (let ((symbol-at-point (thing-at-point 'symbol)))
      (when symbol-at-point (let* ((regexp (concat (regexp-quote symbol-at-point) "$"))
                                   (matching-symbols (delq nil (mapcar
                                                                (lambda (symbol)
                                                                  (if (string-match regexp symbol)
                                                                      symbol))
                                                                symbol-names))))
                              (when matching-symbols (sort matching-symbols
                                                           (lambda (a b)
                                                             (> (length a)
                                                                (length b))))
                                    (mapc
                                     (lambda (symbol)
                                       (setq symbol-names (cons symbol (delete symbol
                                                                               symbol-names))))
                                     matching-symbols)))))
    (let* ((selected-symbol (ido-completing-read "Symbol? " symbol-names))
           (position (cdr (assoc selected-symbol name-and-pos))))
      (goto-char position))))


;; remote edit example
(defun connect-azure ()
  "Example settings for remote edit."
  (interactive)
  (dired "/alauda@139.217.3.183:/home/alauda/"))


(defadvice bookmark-jump (after bookmark-jump activate)
  "AFTER BOOKMARK-JUMP ACTIVATE."
  (let ((latest (bookmark-get-bookmark bookmark)))
    (setq bookmark-alist (delq latest bookmark-alist))
    (add-to-list 'bookmark-alist latest)))



(defun copy-line
    (&optional
     arg)
  "Do a `kill-line` but copy rather than kill.  This function directly calls
    kill-line, so see documentation of kill-line for how to use it including prefix
    argument and relevant variables.  This function works by temporarily making the
    buffer read-only."
  (interactive "P")
  (let ((buffer-read-only t)
        (kill-read-only-ok t))
    (kill-line arg)))
;; optional key binding




(defun xah-select-text-in-quote ()
  "Select text between the nearest left and right delimiters.
Delimiters here includes the following chars: \"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）
This command select between any bracket chars, not the inner text of a bracket. For example, if text is

 (a(b)c▮)

 the selected char is “c”, not “a(b)c”.

URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2016-12-18"
  (interactive)
  (let ((-skipChars (if (boundp 'xah-brackets)
                        (concat "^\"" xah-brackets)
                      "^\"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）")) -pos)
    (skip-chars-backward -skipChars)
    (setq -pos (point))
    (skip-chars-forward -skipChars)
    (set-mark -pos)))



(defvar symbol-pairs '(("\"" . "\"")
                       ("(" . ")")
                       ("[" . "]")
                       ("'" . "'")
                       (" " . " ")))


;; copy symbols between pair
(defun copy-in-pair ()
  "Copy token or string in pair."
  (interactive)
  (let ((point-start (point)))
    (let ((match-char
           (buffer-substring
            point-start
            (+ point-start 1))))
      (right-char)
      (let ((point-end (search-forward (cdr (assoc match-char symbol-pairs))) ))
        (message "Mark: %s"
                 (buffer-substring
                  (+ 1 point-start)
                  (- point-end 1)))
        (copy-region-as-kill (+ 1 point-start)
                             (- point-end 1))))))






(defun my-shell-execute(cmd)
  (interactive "sShell command: ")
  (shell (get-buffer-create "my-shell-buf"))
  (process-send-string (get-buffer-process "my-shell-buf")
                       (concat cmd "\n")))

;; translate word at point
(defun yd-trans-word ()
  "Translate word at point."
  (interactive)
  (let ((word))
    (setq word (thing-at-point 'word 'no-properties))
    (setq script "~/.emacs.d/script/ydcv.py")
    (my-shell-execute ( format "python %s %s" script word))))



(defun side-ibuffer ()
  (interactive)
  (let (( buffer (save-window-excursion (ibuffer nil "*side-ibuffer*")
                                        (setq-local buffer-stale-function
                                                    (lambda
                                                      (&rest
                                                       ignore)
                                                      t))
                                        (setq-local revert-buffer-function
                                                    (lambda
                                                      (&rest
                                                       ignore)
                                                      (ibuffer-update nil t)))
                                        (auto-revert-mode)
                                        (current-buffer))))
    (pop-to-buffer buffer '(display-buffer-in-side-window (side . left)))))










(defun toggle-quotes ()
  "Toggle single quoted string to double or vice versa.
and flip the internal quotes as well.  Best to run on the first
 character of the string."
  (interactive)
  (save-excursion (re-search-backward "[\"']")
                  (let* ((start (point))
                         (old-c (char-after start)) new-c)
                    (setq new-c (case old-c (?\" "'")
                                      (?\' "\"")))
                    (setq old-c (char-to-string old-c))
                    (delete-char 1)
                    (insert new-c)
                    (re-search-forward old-c)
                    (backward-char 1)
                    (let ((end (point)))
                      (delete-char 1)
                      (insert new-c)
                      (replace-string new-c old-c nil (1+ start) end)))))




;; Move Cursor to Beginning of Line/Paragraph
;; http://ergoemacs.org/emacs/emacs_keybinding_design_beginning-of-line-or-block.html

(defun xah-beginning-of-line-or-block ()
  "Move cursor to beginning of line or previous paragraph.

• When called first time, move cursor to beginning of char in current line.
  (if already, move to beginning of line.)
• When called again, move cursor backward by jumping over any sequence of
  whitespaces containing 2 blank lines.

Version 2017-05-04"
  (interactive)
  (let ((-p (point)))
    (if (equal last-command this-command )
        (if (re-search-backward "\n[\t\n ]*\n+" nil "NOERROR")
            (progn (skip-chars-backward "\n\t ")
                   (forward-char ))
          (goto-char (point-min)))
      (progn (back-to-indentation)
             (when (eq -p (point))
               (beginning-of-line))))))

(defun xah-end-of-line-or-block ()
  "Move cursor to end of line or next paragraph.

• When called first time, move cursor to end of line.
• When called again, move cursor forward by jumping over any sequence
of whitespaces containing 2 blank lines.
Version 2017-05-04"
  (interactive)
  (if (or (equal (point)
                 (line-end-position))
          (equal last-command this-command ))
      (when (re-search-forward "\n[\t\n ]*\n+" nil "NOERROR" )
        (progn (end-of-line )))
    (end-of-line)))


(provide 'init-func)
;;; Init-func.el ends here
