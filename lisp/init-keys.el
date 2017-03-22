;; buffers
(global-set-key (kbd "C-c b k") 'only-current-buffer)



;; pop mark (disable orgin mail compre command
(define-key  global-map  "\C-xm"  'pop-to-mark-command)
(define-key global-map "\C-xp" 'package-install)

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)



;; editing
(global-set-key (kbd "C-c v f") 'hs-toggle-hiding)


;; M-x
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


;; ido
(global-set-key (kbd "C-x C-i") 'ido-imenu)
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)




(provide 'init-keys)
