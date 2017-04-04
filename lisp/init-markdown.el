(when (maybe-require-package 'markdown-mode)
  (after-load 'whitespace-cleanup-mode (push 'markdown-mode whitespace-cleanup-mode-ignore-modes)))


(add-hook 'markdown-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-i") 'ido-imenu)))

(require-package 'markdown-toc)

(add-hook 'markdown-mode-hook #'markdownfmt-enable-on-save)

(provide 'init-markdown)
