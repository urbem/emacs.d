;; Use smex to handle M-x
(when (maybe-require-package 'smex)
  ;; Change path for ~/.smex-items
  (smex-initialize)
  (global-set-key [remap execute-extended-command] 'smex))

(provide 'init-smex)
