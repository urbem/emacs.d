;;; init-packages -- install some useful packages
;;; Commentary:
;; Copyright (C) 2017  Hang Yan
;; Author: Hang Yan <hangyan@hotmail.com>

;;; Code:

(require-package 'dash)
(eval-after-load 'dash '(dash-enable-font-lock))


;;-map
;; 'require-package
;; '(wgrep project-local-variables diminish scratch mwe-log-commands ecb py-autopep8 s icicles))

(provide 'init-packages)
;;; init-packages.el ends here
