;; frame title
(setq frame-title-format
      '("" invocation-name "-" emacs-version "@" short-hostname ": %b"))

(defconst user-default-fg "#aaaaaa")
(defconst user-default-bg "#1f1f1f")
(defconst user-face-alist
  `((default
      :foreground ,user-default-fg
      :background ,user-default-bg)
    (region                          :background "#8c8ce8")
    (mode-line :foreground "#8fb28f" :background "#3f3f3f" :box nil)
    (mode-line-inactive              :background "#5f5f5f" :box nil)
    (header-line                     :background "#3f3f3f" :box nil))
  "User defined face attributes to override default faces or theme faces.")

;; madhat2r-theme
(setq frame-background-mode 'dark)
(el-get-lock-unlock 'madhat2r-theme)
(el-get-bundle madhat2r-theme
  (add-to-list 'custom-theme-load-path
               (expand-file-name "madhat2r-theme" el-get-dir))
  (load-theme 'madhat2r t)
  ;; apply user defined faces
  (let* ((class '((class color) (min-colors 89)))
         (to-spec #'(lambda (elt) `(,(car elt) ((,class ,(cdr elt))))))
         (faces (mapcar to-spec user-face-alist)))
    (apply #'custom-theme-set-faces `(user ,@faces))))

;; ;; theme
;; (setq frame-background-mode 'dark)
;; (defvar zenburn-override-colors-alist
;;   `(("zenburn-fg" . ,user-default-fg)
;;     ("zenburn-bg" . ,user-default-bg)))
;; (if (not (and (>= emacs-major-version 24) (>= emacs-minor-version 1)))
;;     (el-get-bundle color-theme
;;       (color-theme-initialize)
;;       (color-theme-dark-laptop)
;;       ;; apply user defined faces
;;       (dolist (elt user-face-alist)
;;         (let ((name (car elt)) (attrs (cdr elt)))
;;           (apply #'set-face-attribute `(,name nil ,@attrs)))))
;;   (el-get-lock-unlock 'zenburn-theme)
;;   (el-get-bundle zenburn-theme
;;     :url "http://raw.github.com/bbatsov/zenburn-emacs/master/zenburn-theme.el"
;;     (add-to-list 'custom-theme-load-path
;;                  (expand-file-name "zenburn-theme" el-get-dir))
;;     (load-theme 'zenburn t)
;;     ;; apply user defined faces
;;     (let* ((class '((class color) (min-colors 89)))
;;            (to-spec #'(lambda (elt) `(,(car elt) ((,class ,(cdr elt))))))
;;            (faces (mapcar to-spec user-face-alist)))
;;       (apply #'custom-theme-set-faces `(user ,@faces)))))

;; fix for non-frame mode; set face color explicitly
(dolist (face '(default mode-line))
  (let ((attrs (cdr (assq face user-face-alist))))
    (set-face-foreground face (plist-get attrs :foreground))
    (set-face-background face (plist-get attrs :background))))

;; ;; highlight specific keywords in comments
;; (el-get-bundle fic-mode
;;   (add-hook 'prog-mode-hook #'fic-mode) ;; Emacs 24
;;   (add-hook 'cperl-mode-hook #'fic-mode)
;;   (with-eval-after-load-feature 'fic-mode
;;     (push "XXX" fic-highlighted-words)
;;     (dolist (face '(fic-face fic-author-face))
;;       (set-face-foreground face "#d0bf8f")
;;       (set-face-background face "gray40"))))

;; scroll bar
(el-get-bundle yascroll (global-yascroll-bar-mode))

;; ;; line-wrap character
;; (require 'disp-table)
;; (defface wrap-face
;;   '((((class color) (min-colors 88) (background dark))
;;      :foreground "aquamarine4")
;;     (((class color) (min-colors 88) (background light))
;;      :foreground "aquamarine2")
;;     (((class color) (min-colors 16))
;;      :foreground "DarkCyan")
;;     (((class color) (min-colors 8))
;;      :foreground "gray")
;;     (((type tty) (class mono))
;;      :inverse-video t))
;;   "Face of the wrap."
;;   :group 'convenience)
;; (set-display-table-slot standard-display-table 'wrap
;;                         (make-glyph-code #xbb 'wrap-face))

;; visualize whitespace
(with-eval-after-load-feature 'whitespace
  (setq whitespace-global-modes '(not)
        whitespace-style '(face tabs tab-mark fw-space-mark lines-tail))
  ;; tab
  (setcar (nthcdr 2 (assq 'tab-mark whitespace-display-mappings)) [?> ?\t])
  (let ((face  'whitespace-tab))
    (set-face-background face nil)
    (set-face-attribute face nil :foreground "gray30" :strike-through t))
  ;; full-width space
  (defface full-width-space
    '((((class color) (background light)) (:foreground "azure3"))
      (((class color) (background dark)) (:foreground "pink4")))
    "Face for full-width space"
    :group 'whitespace)
  (let ((fw-space-mark (make-glyph-code #x25a1 'full-width-space)))
    (add-to-list 'whitespace-display-mappings
                 `(fw-space-mark ???? ,(vector fw-space-mark)))))
;; patch
(defsubst whitespace-char-or-glyph-code-valid-p (char)
  (let ((char (if (consp char) (car char) char)))
    (or (< char 256) (characterp char))))
(defadvice whitespace-display-vector-p (around improved-version activate)
  (let ((i (length vec)))
    (when (> i 0)
      (while (and (>= (setq i (1- i)) 0)
                  (whitespace-char-or-glyph-code-valid-p (aref vec i))))
      (setq ad-return-value (< i 0)))))
;; activate
(global-whitespace-mode)

;; show trailing whitespace
(setq-default show-trailing-whitespace t)
(add-hook 'comint-mode-hook #'(lambda() (setq show-trailing-whitespace nil)))

;; parenthesis
(show-paren-mode t)

;; ;; hide-show
;; (defun hs-enable ()
;;   (interactive)
;;   (hs-minor-mode)
;;   (local-set-key (kbd "C-c h") 'hs-hide-block)
;;   (local-set-key (kbd "C-c s") 'hs-show-block)
;;   (local-set-key (kbd "C-c l") 'hs-hide-level))

;; set mode-line-inactive face
(set-face-attribute 'mode-line-inactive nil :background "gray10" :foreground "snow4")
