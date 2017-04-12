;; buffers



;; pop mark (disable orgin mail compre command



(global-set-key (kbd "s-<up>") 'windmove-up)
(global-set-key (kbd "s-<down>") 'windmove-down)
(global-set-key (kbd "s-<left>") 'windmove-left)
(global-set-key (kbd "s-<right>") 'windmove-right)

(global-unset-key (kbd "C-c c"))
(global-set-key "\C-cy"
                '(lambda ()
                   (interactive)
                   (popup-menu 'yank-menu)))

(global-set-key (kbd "C-c c p") 'copy-in-pair)
(global-set-key (kbd "C-c w l") 'yd-trans-word)
(global-set-key (kbd "C-c v f") 'hs-toggle-hiding)
(global-set-key (kbd "C-c j d") 'dumb-jump-go)
(global-set-key (kbd "C-c h l") 'helm-locate)
(global-set-key (kbd "C-c h r") 'helm-recentf)
(global-set-key (kbd "C-c h b") 'helm-bookmarks)
(global-set-key (kbd "C-c b k") 'only-current-buffer)


(global-set-key "\C-c\C-k" 'copy-line)

(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(global-set-key (kbd "C-x C-k") 'delete-current-buffer-file)
(global-set-key (kbd "C-x C-.") 'pop-global-mark)
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(define-key  global-map  "\C-xm"  'pop-to-mark-command)


(global-set-key (kbd "M-j")
                (lambda ()
                  (interactive)
                  (join-line -1)))
(global-set-key (kbd "s-.") 'set-mark-command)


(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)



(global-set-key (kbd "<f4>") 'helm-imenu)





(provide 'init-keys)
;;; init-keys.el ends here
