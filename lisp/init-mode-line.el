;;; init-mode-line -- mode line
;;; Commentary:
;; Copyright (C) 2017  Hang Yan
;; Author: Hang Yan <hangyan@hotmail.com>

;;; Code:


;;(require 'spaceline-config)
;;(spaceline-emacs-theme)
;;(spaceline-helm-mode)

(require-package 'smart-mode-line)
(sml/setup)
(setq sml/theme 'dark)

(provide 'init-mode-line)
;;; init-mode-line.el ends here
