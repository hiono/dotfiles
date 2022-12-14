;; emacs directory

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(let ((versioned-dir (locate-user-emacs-file (format "v%s" emacs-version))))
  (setq-default el-get-dir (expand-file-name "el-get" versioned-dir)
                package-user-dir (expand-file-name "elpa" versioned-dir)))

;; bundle (an El-Get wrapper)
(add-to-list 'load-path (expand-file-name "el-get" el-get-dir))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))
;; (unless (require 'el-get nil 'noerror)
;;   (require 'package)
;;   (add-to-list 'package-archives
;;                '("melpa" . "http://melpa.org/packages/"))
;;   (package-refresh-contents)
;;   (package-initialize)
;;   (package-install 'el-get)
;;   (require 'el-get))
(add-to-list 'el-get-recipe-path (locate-user-emacs-file "recipes"))

;; lock the pacakge versions
(el-get-bundle tarao/el-get-lock
  (el-get-lock)
  (el-get-lock-unlock 'el-get))

(el-get-bundle with-eval-after-load-feature)

;; put site-lisp and its subdirectories into load-path
(when (fboundp 'normal-top-level-add-subdirs-to-load-path)
  (let* ((dir (locate-user-emacs-file "site-lisp"))
         (default-directory dir))
    (when (file-directory-p dir)
      (add-to-list 'load-path dir)
      (normal-top-level-add-subdirs-to-load-path))))

;; load init files
(el-get-bundle! emacs-jp/init-loader)
;; load
(setq-default init-loader-show-log-after-init nil
              init-loader-byte-compile t)
(init-loader-load (locate-user-emacs-file "init-loader"))

(el-get 'sync)

;; hide compilation results
(let ((win (get-buffer-window "*Compile-Log*")))
  (when win (delete-window win)))

;; (setq mail-user-agent 'message-user-agent)
;; ;; Set my default sending details:
;; (setq user-mail-address "hiroyuki.ono.jc@renesas.com"
;;       user-full-name "Hiroyuki Ono")
;; ;; Configured the SMTP server info for Outlook
;; (setq smtpmail-stream-type 'ssl
;;       smtpmail-smtp-server "smtp.office365.com"
;;       smtpmail-smtp-service 587)
;; (setq message-send-mail-function 'message-smtpmail-send-it)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-matching-paren t)
 '(column-number-mode t)
 '(indicate-buffer-boundaries (quote right))
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(linum-format "%5d ")
 '(menu-bar-mode nil)
 '(notmuch-saved-searches
   (quote
    ((:name "inbox" :query "tag:inbox" :key "i")
     (:name "unread" :query "tag:unread" :key "u")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "t")
     (:name "drafts" :query "tag:draft" :key "d")
     (:name "all mail" :query "*" :key "a")
     (:name "??????" :query "?????? srsp2@")
     (:name "Today" :query "today"))))
 '(package-selected-packages (quote (ag cmake-mode fish-mode)))
 '(send-mail-function (quote mailclient-send-it))
 '(tool-bar-mode nil)
 '(tramp-syntax (quote default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((class color) (min-colors 89)) (:foreground "#aaaaaa" :background "#1f1f1f"))))
 '(header-line ((((class color) (min-colors 89)) (:background "#3f3f3f" :box nil))))
 '(mode-line ((((class color) (min-colors 89)) (:foreground "#8fb28f" :background "#3f3f3f" :box nil))))
 '(mode-line-inactive ((((class color) (min-colors 89)) (:background "#5f5f5f" :box nil))))
 '(region ((((class color) (min-colors 89)) (:background "#8c8ce8")))))
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'upcase-region 'disabled nil)
