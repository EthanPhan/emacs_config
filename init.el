
;; Load jedi config

(when
    (load
     (expand-file-name "~/.emacs.d/lisp/jedi-starter.el"))
  (package-initialize))

;; Pymacs
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")

;; CUSTOMIZATION

;;(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally
(global-hl-line-mode +1) ;; enable line highlighting
(set-face-background 'hl-line "#1B4F72")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/Workplace/ORGs/handshakes.org")))
 '(package-selected-packages
   (quote
    (smartrep request ein magit dracula-theme py-autopep8 projectile material-theme jedi flycheck elpy better-defaults))))

;; Install org mode
(unless (package-installed-p 'org)
    (package-refresh-contents)
    (package-install 'org))

;; Key binding for org mode
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)


;; -*- mode: elisp -*-

;; Disable the splash screen (to enable it agin, replace the t with 0)
(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;;;;Org mode configuration
;; Enable Org mode
(require 'org)
;; Make Org mode work with files ending in .org
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen

;; org mode todo config
(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

;; If multiple-cursors is not installed, install it.
(unless (package-installed-p 'multiple-cursors)
    (package-refresh-contents)
    (package-install 'multiple-cursors))

;; key binding for multiple-cursors
(global-set-key (kbd "C-c m c") 'mc/edit-lines)

;; If jupyter is not installed, install it.
(unless (package-installed-p 'jupyter)
    (package-refresh-contents)
    (package-install 'jupyter))

;; If org-bullets is not installed, install it.
(unless (package-installed-p 'org-bullets)
    (package-refresh-contents)
    (package-install 'org-bullets))

;; If use-package is not installed, install it.
(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

;; Markdown mode

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "markdown"))

;; Sync emacs buffer with system buffer
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;; Untabify before save
(defun untabify-except-makefiles ()
  "Replace tabs with spaces except in makefiles."
  (unless (derived-mode-p 'makefile-mode)
    (untabify (point-min) (point-max))))

(add-hook 'before-save-hook 'untabify-except-makefiles)

;; Load theme manually
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'dracula t)

;; key binding for magit
(global-set-key (kbd "C-x g") 'magit-status)

;; key binding for mark next
(global-set-key (kbd "C-c m n") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c m a") 'mc/mark-all-like-this)

;; Load python template
(add-hook 'find-file-hooks 'maybe-load-template)
(defun maybe-load-template ()
(interactive)
(when (and
(string-match "\\.py$" (buffer-file-name))
(eq 1 (point-max)))
  (insert-file "~/.emacs.d/templates/template.py")))

;; Customizations for org mode

;; hide the emphasis markup (e.g. /.../ for italics, *...* for bold, etc.)
(setq org-hide-emphasis-markers t)

;; The org-bullets package replaces all headline markers with different Unicode bullets
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; init.el ends here
