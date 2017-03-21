(defun kill-some-buffer (buffer)
  "Ignore some buffers."
  (if (member (buffer-name buffer) '("*Messages*" "*anaconda-mode*"))
      (message "Ignore you : %s" (buffer-name Buffer))
    (kill-buffer buffer)))


(defun only-current-buffer ()
  "Kill other buffers."
  (interactive)
  (mapc 'kill-some-buffer (cdr (buffer-list (current-buffer)))))



(provide 'init-func)
;;; init-func.el ends here
