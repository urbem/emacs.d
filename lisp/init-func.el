(defun kill-some-buffer (buffer)
  "Ignore some buffers."
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
  (let ((latest (bookmark-get-bookmark bookmark)))
    (setq bookmark-alist (delq latest bookmark-alist))
    (add-to-list 'bookmark-alist latest)))



(defun copy-line
    (&optional
     arg)
  "Do a kill-line but copy rather than kill.  This function directly calls
    kill-line, so see documentation of kill-line for how to use it including prefix
    argument and relevant variables.  This function works by temporarily making the
    buffer read-only."
  (interactive "P")
  (let ((buffer-read-only t)
        (kill-read-only-ok t))
    (kill-line arg)))
;; optional key binding
(global-set-key "\C-c\C-k" 'copy-line)


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




(provide 'init-func)
;;; Init-func.el ends here
