;;----------------------------------------------------------------------------
;; Stop C-z from minimizing windows under OS X
;;----------------------------------------------------------------------------
(defun sanityinc/maybe-suspend-frame ()
  (interactive)
  (unless (and *is-a-mac*
               window-system)
    (suspend-frame)))

(global-set-key (kbd "C-z") 'sanityinc/maybe-suspend-frame)


;;----------------------------------------------------------------------------
;; Suppress GUI features
;;----------------------------------------------------------------------------
(setq use-file-dialog nil)
(setq use-dialog-box nil)
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)


;;----------------------------------------------------------------------------
;; Show a marker in the left fringe for lines not in the buffer
;;----------------------------------------------------------------------------
(setq indicate-empty-lines t)


;;----------------------------------------------------------------------------
;; Window size and features
;;----------------------------------------------------------------------------
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'set-scroll-bar-mode)
  (set-scroll-bar-mode nil))

(let ((no-border '(internal-border-width . 0)))
  (add-to-list 'default-frame-alist no-border)
  (add-to-list 'initial-frame-alist no-border))

(defun sanityinc/adjust-opacity (frame incr)
  "Adjust the background opacity of FRAME by increment INCR."
  (unless (display-graphic-p frame)
    (error
     "Cannot adjust opacity of this frame"))
  (let* ((oldalpha (or (frame-parameter frame 'alpha)
                       100))
         ;; The 'alpha frame param became a pair at some point in
         ;; emacs 24.x, e.g. (100 100)
         (oldalpha (if (listp oldalpha)
                       (car oldalpha) oldalpha))
         (newalpha (+ incr oldalpha)))
    (when (and (<= frame-alpha-lower-limit newalpha)
               (>= 100 newalpha))
      (modify-frame-parameters frame (list (cons 'alpha newalpha))))))

(when (and *is-a-mac*
           (fboundp 'toggle-frame-fullscreen))
  ;; Command-Option-f to toggle fullscreen mode
  ;; Hint: Customize `ns-use-native-fullscreen'
  (global-set-key (kbd "M-ƒ") 'toggle-frame-fullscreen))

;; TODO: use seethru package instead?
(global-set-key (kbd "M-C-8")
                (lambda ()
                  (interactive)
                  (sanityinc/adjust-opacity nil -2)))
(global-set-key (kbd "M-C-9")
                (lambda ()
                  (interactive)
                  (sanityinc/adjust-opacity nil 2)))
(global-set-key (kbd "M-C-0")
                (lambda ()
                  (interactive)
                  (modify-frame-parameters nil `((alpha . 100)))))

(add-hook 'after-make-frame-functions
          (lambda (frame)
            (with-selected-frame frame (unless window-system (set-frame-parameter nil
                                                                                  'menu-bar-lines
                                                                                  0)))))

(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name)) "%b"))))

;; Non-zero values for `line-spacing' can mess up ansi-term and co,
;; so we zero it explicitly in those cases.
(add-hook 'term-mode-hook
          (lambda ()
            (setq line-spacing 0)))

(require-package 'disable-mouse)

;; linum
(global-linum-mode t)
(column-number-mode t)


;; hightlight current line
;;(global-hl-line-mode 1)

;; ruler
;; we have dynamic-ruler now
;; (add-hook 'prog-mode-hook 'ruler-mode)
(modify-all-frames-parameters (list (cons 'cursor-type 'bar)))
(set-cursor-color "yellow")


;; Change cursor color according to mode
(defvar hcz-set-cursor-color-color "")
(defvar hcz-set-cursor-color-buffer "")
(defun hcz-set-cursor-color-according-to-mode ()
  "Change cursor color according to some minor modes."
  ;; set-cursor-color is somewhat costly, so we only call it when needed:
  (let ((color (if buffer-read-only "white" (if overwrite-mode "red" "yellow"))))
    (unless (and (string= color hcz-set-cursor-color-color)
                 (string= (buffer-name) hcz-set-cursor-color-buffer))
      (set-cursor-color
       (setq hcz-set-cursor-color-color color))
      (setq hcz-set-cursor-color-buffer (buffer-name)))))
;;(add-hook 'post-command-hook 'hcz-set-cursor-color-according-to-mode)



;; scrolling
;; smooth scrolling
;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(2 ((shift) . 2))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)       ;; scroll window under mouse
(setq scroll-step 2) ;; keyboard Scroll one line at a time


;; volatile-highlight
(require-package 'volatile-highlights)
(volatile-highlights-mode t)

(defun neotree-project-dir-toggle ()
  "Open NeoTree using the project root, using find-file-in-project,
or the current buffer directory."
  (interactive)
  (let ((project-dir (ignore-errors
;;; Pick one: projectile or find-file-in-project
                                        ; (projectile-project-root)
                       (ffip-project-root)))
        (file-name (buffer-file-name))
        (neo-smart-open t))
    (if (and (fboundp 'neo-global--window-exists-p)
             (neo-global--window-exists-p))
        (neotree-hide)
      (progn (neotree-show)
             (if project-dir (neotree-dir project-dir))
             (if file-name (neotree-find file-name))))))


;; neotree
;; ---> package-install all-the-icons
;; ---> all-the-icons-install-fonts
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(global-set-key [f5] 'neotree-project-dir-toggle)


;; force set font
;; Set default font
;; link: https://emacs.stackexchange.com/questions/2501/how-can-i-set-default-font-in-emacs
(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 120
                    :weight 'normal
                    :width 'normal)

(provide 'init-gui-frames)
