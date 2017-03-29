;; ecb
(setq ecb-examples-bufferinfo-buffer-name "ecb-examples")

(setq ecb-minor-mode nil)
(defun display-buffer-at-bottom--display-buffer-at-bottom-around (orig-fun &rest args)
  "Bugfix for ECB: cannot use display-buffer-at-bottom', calldisplay-buffer-use-some-window' instead in ECB frame."
  (if (and ecb-minor-mode (equal (selected-frame) ecb-frame))
      (apply 'display-buffer-use-some-window args)
    (apply orig-fun args)))
(advice-add 'display-buffer-at-bottom :around #'display-buffer-at-bottom--display-buffer-at-bottom-around)

(setq ecb-tip-of-the-day nil)

(global-set-key (kbd "C-c b a") 'ecb-activate)
(global-set-key (kbd "C-c b d") 'ecb-deactivate)


(provide 'init-ecb)
