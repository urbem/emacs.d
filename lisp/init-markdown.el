(when (maybe-require-package 'markdown-mode)
  (after-load 'whitespace-cleanup-mode (push 'markdown-mode whitespace-cleanup-mode-ignore-modes)))


(add-hook 'markdown-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-i") 'ido-imenu)))

(require-package 'markdown-toc)

;; finally
;;(setq markdown-css-paths (list "http://thomasf.github.io/solarized-css/solarized-light.min.css"))
(setq markdown-css-paths (list
                          "https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/dark.css"))
;; (setq markdown-css-paths (list "http://thomasf.github.io/solarized-css/solarized-dark.min.css"))

;; index
(add-hook 'markdown-mode-hook 'imenu-add-menubar-index)
(setq imenu-auto-rescan t)


;; imenu-list
(setq imenu-list-auto-resize t)

;; auto space
(require 'pangu-spacing)
(global-pangu-spacing-mode 1)

(add-hook 'markdown-mode-hook
          '(lambda ()
             (set (make-local-variable 'pangu-spacing-real-insert-separtor) t)))


(provide 'init-markdown)
