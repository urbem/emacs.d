(require-package 'go-mode)
(require 'go-bimenu)
(require-package 'golint)
(require-package 'go-guru)
(require-package 'go-add-tags)
(require-package 'godoctor)
(require-package 'go-playground)
(require-package 'go-eldoc)
(require-package 'flycheck-gometalinter)
(require-package 'company-go)
(eval-after-load 'flycheck '(add-hook 'flycheck-mode-hook #'flycheck-gometalinter-setup))

;; skips 'vendor' directories and sets GO15VENDOREXPERIMENT=1
(setq flycheck-gometalinter-vendor t)
;; only show errors
(setq flycheck-gometalinter-errors-only t)
;; only run fast linters
(setq flycheck-gometalinter-fast t)
;; use in tests files
(setq flycheck-gometalinter-test t)
;; Set different deadline (default: 5s)
(setq flycheck-gometalinter-deadline "10s")


(exec-path-from-shell-copy-env "GOPATH")
(exec-path-from-shell-copy-env "GOROOT")
(exec-path-from-shell-copy-env "PATH")

(setenv "GOPATH" "/Users/yayu/Golang")
(setenv "GOROOT" "/usr/local/opt/go/libexec")
(setenv "PATH" (concat "/Users/yayu/Golang/bin" ":" (getenv "PATH")))


(add-hook 'go-mode-hook #'go-guru-hl-identifier-mode)
(defun go-get ()
  "Go get package."
  (interactive)
  (shell-command (format "go get %s &"
                         (buffer-substring
                          (mark)
                          (point)))))


(defun my-go-mode-hook ()
  "Use gofmt before save and build cmd."
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (go-eldoc-setup)
  (set (make-local-variable 'compile-command)  "go build -v && go test -v && go vet && golint"))

(add-hook 'go-mode-hook 'my-go-mode-hook)

(add-hook 'go-mode-hook
          (lambda ()
            (local-set-key (kbd "M-.") 'godef-jump)
            (local-set-key (kbd "C-c C-s") 'godoc-at-point)
            (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
            (local-set-key (kbd "C-c C-k") 'godef-jump-back)
            (local-set-key (kbd "C-c C-g") 'go-get)
            (local-set-key (kbd "C-c g m") 'gobimenu-file)
            (local-set-key (kbd "C-c g i") 'go-goto-imports)))


(setq company-tooltip-limit 20)         ; bigger popup window
(setq company-idle-delay .3) ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)  ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

(add-hook 'go-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 '(company-go))
            (company-mode)))

(custom-set-variables '(go-add-tags-style 'lower-camel-case))

(with-eval-after-load 'go-mode (define-key go-mode-map (kbd "C-c t") #'go-add-tags))


(setq flycheck-gometalinter-disable-all t)
(setq flycheck-gometalinter-enable-linters '("golint" "deadcode" "unused" "gas" "staticcheck"
                                             "gosimple" "goconst" "unconvert" "interfacer"
                                             "ineffassign" "dupl" "errcheck" "varcheck" "safesql"
                                             "unparam" "misspell"  "goimports"))

(provide 'init-golang-mode)
