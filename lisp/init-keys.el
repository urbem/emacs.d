;; buffers
(global-set-key (kbd "C-c b k") 'only-current-buffer)



;; pop mark (disable orgin mail compre command
(define-key  global-map  "\C-xm"  'pop-to-mark-command)
(define-key global-map "\C-xp" 'package-install)

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)

;; spell


;; editing
(global-set-key (kbd "C-c v f") 'hs-toggle-hiding)


;; M-x
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


;; ido
(global-set-key (kbd "C-x C-i") 'ido-imenu)
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)



;; disable mouse
(dolist (k '([mouse-1] [down-mouse-1] [drag-mouse-1] [double-mouse-1] [triple-mouse-1]
             [mouse-2] [down-mouse-2] [drag-mouse-2] [double-mouse-2] [triple-mouse-2]
             [mouse-3] [down-mouse-3] [drag-mouse-3] [double-mouse-3] [triple-mouse-3]
             [mouse-4] [down-mouse-4] [drag-mouse-4] [double-mouse-4] [triple-mouse-4]
             [mouse-5] [down-mouse-5] [drag-mouse-5] [double-mouse-5] [triple-mouse-5]))
  (global-unset-key k))



(provide 'init-keys)
