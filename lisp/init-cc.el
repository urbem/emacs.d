;;; init-cc -- c/c++
;;; Commentary:
;; Copyright (C) 2017  Hang Yan
;; Author: Hang Yan <hangyan@hotmail.com>

;;; Code:




(defun cc-reformat-region
    (&optional
     b
     e)
  (interactive "r")
  (when (not (buffer-file-name))
    (error
     "A buffer must be associated with a file in order to use REFORMAT-REGION."))
  (when (not (executable-find "clang-format"))
    (error
     "clang-format not found."))
  (shell-command-on-region b e "clang-format -style=Google" (current-buffer) t)
  (indent-region b e))


(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)


(add-to-list 'auto-mode-alist '("\\.ext\\'" . c-mode))

(add-to-list 'company-backends 'company-c-headers)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)



(provide 'init-cc)
;;; init-cc.el ends here
