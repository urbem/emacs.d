;; buffers
(global-set-key (kbd "C-c b k") 'only-current-buffer)


;; grep
(require 'grep-o-matic)
(define-key 'grep-o-matic-map "\M-]" 'grep-o-matic-repository)

(provide 'init-keys)
