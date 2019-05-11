;;; Character sets


;;; Changing font sizes

(require-package 'default-text-scale)
(global-set-key (kbd "C-M-=") 'default-text-scale-increase)
(global-set-key (kbd "C-M--") 'default-text-scale-decrease)


(defun sanityinc/maybe-adjust-visual-fill-column ()
  "Readjust visual fill column when the global font size is modified.
This is helpful for writeroom-mode, in particular."
  ;; TODO: submit as patch
  (if visual-fill-column-mode (add-hook 'after-setting-font-hook 'visual-fill-column--adjust-window
                                        nil t)
    (remove-hook 'after-setting-font-hook 'visual-fill-column--adjust-window t)))

(add-hook 'visual-fill-column-mode-hook 'sanityinc/maybe-adjust-visual-fill-column)



;; force set font
;; Set default font
;; link: https://emacs.stackexchange.com/questions/2501/how-can-i-set-default-font-in-emacs
(set-face-attribute 'default nil
                    :family "PT Mono"
                    :height 130
                    :weight 'normal
                    :width 'normal)



(provide 'init-fonts)
