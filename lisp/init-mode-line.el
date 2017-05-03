;;; init-mode-line -- mode line
;;; Commentary:
;; Copyright (C) 2017  Hang Yan
;; Author: Hang Yan <hangyan@hotmail.com>

;;; Code:

(require 'powerline)
(require 'moe-theme)

;; Show highlighted buffer-id as decoration. (Default: nil)
(setq moe-theme-highlight-buffer-id t)

;; Resize titles (optional).
(setq moe-theme-resize-markdown-title '(1.5 1.4 1.3 1.2 1.0 1.0))
(setq moe-theme-resize-org-title '(1.5 1.4 1.3 1.2 1.1 1.0 1.0 1.0 1.0))
(setq moe-theme-resizne-rst-title '(1.5 1.4 1.3 1.2 1.1 1.0))


;; Finally, apply moe-theme now.
;; Choose what you like, (moe-light) or (moe-dark)
(moe-dark)

(powerline-moe-theme)




(setq which-func-unknown "⊥"           ; The default is really boring…
      which-func-format
      `((:propertize (" ➤ " which-func-current)
                     local-map
                     ,which-func-keymap
                     face
                     which-func
                     mouse-face
                     mode-line-highlight
                     help-echo
                     "mouse-1: go to beginning\n\
mouse-2: toggle rest visibility\n\
mouse-3: go to end")))

(setq-default header-line-format '(which-func-mode ("" which-func-format " ")))

(which-func-mode)

(provide 'init-mode-line)
;;; init-mode-line.el ends here
