;;; package --- spell check

;;; code

(require 'ispell)


;; spell
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)


(setq ispell-program-name "/usr/local/bin/ispell")
(setq ispell-personal-dictionary "~/.emacs.d/data/ispell_english")


(defun my-save-word ()
  (interactive)
  (let ((current-location (point))
        (word (flyspell-get-word)))
    (when (consp word)
      (flyspell-do-correct 'save nil (car word) current-location (cadr word) (caddr word) current-location)
      (message "Save the world..."))))



(global-set-key (kbd "C-c i s") 'my-save-word)

(when (executable-find ispell-program-name)
  (require 'init-flyspell))

(provide 'init-spelling)

;;; init-spelling ends here
