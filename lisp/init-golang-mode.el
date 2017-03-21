(require 'go-mode)

(setenv "GOPATH" "/Users/yayu/Golang")
(setq exec-path (append '("/Users/yayu/Golang/bin") exec-path))


(require 'go-bimenu)


(defun go-get ()
  (interactive)
  (shell-command (format "go get %s &" (buffer-substring (mark) (point))))
  )


(defun my-go-mode-hook ()
  "Use gofmt before save and build cmd."
  (add-hook 'before-save-hook 'gofmt-before-save)
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet")))

(add-hook 'go-mode-hook 'my-go-mode-hook)

(add-hook 'go-mode-hook (lambda ()
                          (local-set-key (kbd "C-c C-s") 'godoc-at-point)
                          (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
                          (local-set-key (kbd "C-c C-k") 'godef-jump-back)
                          (local-set-key (kbd "C-c C-g") 'go-get)
                          (local-set-key (kbd "C-c C-b") 'gobimenu-file)
                          (local-set-key (kbd "C-c i") 'go-goto-imports)))

(provide 'init-golang-mode)
