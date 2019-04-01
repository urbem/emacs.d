(when (maybe-require-package 'markdown-mode)
  (after-load 'whitespace-cleanup-mode (push 'markdown-mode whitespace-cleanup-mode-ignore-modes)))


(add-hook 'markdown-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-i") 'ido-imenu)
            (imenu-list)))

(require-package 'markdown-toc)

;; finally
(setq markdown-css-paths (list "http://thomasf.github.io/solarized-css/solarized-light.min.css"))

;; index
(add-hook 'markdown-mode-hook 'imenu-add-menubar-index)
(setq imenu-auto-rescan t)


;; imenu-list
(setq imenu-list-auto-resize t)

(add-hook 'markdown-mode-hook
          (lambda ()
            (set-frame-parameter (window-frame) 'background-mode 'dark)
            (enable-theme 'sanityinc-solarized-light)))

(provide 'init-markdown)
