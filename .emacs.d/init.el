
;;;; Initialize ;;;;


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(defun emacs-d (filename)
  "Expand FILENAME relative to `user-emacs-directory'."
  (expand-file-name filename user-emacs-directory))

(require 'cask "/usr/local/share/emacs/site-lisp/cask/cask.el")
(cask-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(require 'use-package)

;; Add /usr/local/bin to path
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

(setq default-directory (getenv "HOME"))

(server-start)

(use-package better-defaults)

;;;; Editor ;;;;

(when (window-system)
  (set-default-font "Fira Code Light")) 

;; Enable ligatures
(mac-auto-operator-composition-mode)

(setq inhibit-startup-message t)
(blink-cursor-mode 0)
(menu-bar-mode 1)

;; Disable annoying visible bell on OSX
(setq visible-bell nil)

;; Actually, why not disable the annoying audible bell as well
(setq ring-bell-function 'ignore)

;; Mac Emacs settings
;; (setq mac-option-modifier 'meta)
;;(setq mac-command-modifier 'super)
;(setq fast-but-imprecise-scrolling t)
(setq focus-follows-mouse t)
(setq mouse-autoselect-window t)
;; Buffer settings
(setq default-indicate-empty-lines t)
(setq require-final-newline t)
(setq show-trailing-whitespace t)
(setq truncate-lines t)

;; Color theme
(load-theme 'weft t)
;; (require 'apropospriate)
;; (load-theme 'apropospriate-dark t)

;; Custom mode-line
(use-package powerline
  :init
  (use-package diminish
    :config
    (progn
      (eval-after-load "undo-tree" '(diminish 'undo-tree-mode))
      (eval-after-load "simple" '(diminish 'auto-fill-function))
      (eval-after-load "eldoc" '(diminish 'eldoc-mode))
      (eval-after-load "guide-key" '(diminish 'guide-key-mode))
      (eval-after-load "highlight-parentheses" '(diminish 'highlight-parentheses-mode))
      (eval-after-load "elisp-slime-nav" '(diminish 'elisp-slime-nav-mode " sln"))
      (eval-after-load "projectile" '(diminish 'projectile-mode " prj"))
      (eval-after-load "parinfer" '(diminish 'parinfer-mode " par"))
      (eval-after-load "company" '(diminish 'company-mode " cmp"))
      (eval-after-load "cider" '(diminish 'cider-mode " cid"))
      (eval-after-load "typed-clojure-mode" '(diminish 'typed-clojure-mode " typ"))
      (eval-after-load "org-indent" '(diminish 'org-indent-mode))
      (eval-after-load "evil-org" '(diminish 'evil-org-mode))
      (eval-after-load "autorevert" '(diminish 'auto-revert-mode))))
  :config
  (progn
    (require 'weft-powerline)
    (powerline-weft-theme)))

;; No slow stupid flyspell. Die!
(eval-after-load "flyspell"
  '(defun flyspell-mode (&optional arg)))

;;;; Global keybindings ;;;;

(global-set-key (kbd "s-x") 'kill-region)
(global-set-key (kbd "s-c") 'kill-ring-save)
(global-set-key (kbd "s-v") 'yank)

(global-set-key (kbd "s-z") 'undo)

(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-w") 'delete-window)
(global-set-key (kbd "s-q") 'save-buffers-kill-terminal)

;;;; Modes ;;;;

(add-hook 'emacs-lisp-mode-hook 'prettify-symbols-mode)
(add-hook 'clojure-mode-hook 'prettify-symbols-mode)

(use-package parinfer
  :ensure t
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
             evil           ; If you use Evil.
             paredit        ; Introduce some paredit commands.
             smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
             smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(use-package paren-face
  :init
  (global-paren-face-mode)
  :config
  (add-hook 'clojure-mode-hook (lambda () (setq paren-face-regexp "#?[](){}[]"))))

(use-package company
  :init (global-company-mode)
  :config
  (progn
    (defun indent-or-complete ()
      (interactive)
      (if (looking-at "\\_>")
          (company-complete-common)
        (indent-according-to-mode)))

    (global-set-key "\t" 'indent-or-complete)))

(use-package magit)

(use-package meghanada)

(use-package sql-mode
  :init
  (progn (setq sql-mysql-options '("--skip-secure-auth")))
  :mode (("\\.zsql$" . sql-mode)
         ("\\.sql$" . sql-mode)))

(use-package evil
  :init
  (progn
    (evil-mode 1)
    (use-package evil-leader
      :init (global-evil-leader-mode)
      :config
      (progn
        (evil-leader/set-leader "SPC")
        (evil-leader/set-key "wd" 'delete-window)
        (evil-leader/set-key "wo" 'delete-other-windows)
        (evil-leader/set-key "ws" 'split-window-below)
        (evil-leader/set-key "wh" 'split-window-horizontally)
        (evil-leader/set-key "wv" 'split-window-vertically)
        (evil-leader/set-key "ww" 'other-window)))
    (use-package evil-magit
      :config
      (progn
        (evil-leader/set-key "gs" 'magit-status)))
    (use-package evil-org
      :init (add-hook 'org-mode-hook 'evil-org-mode))
    (use-package evil-surround
      :init (global-evil-surround-mode 1)
      :config
      (progn
        (add-to-list 'evil-surround-operator-alist '(evil-cp-change . change))
        (add-to-list 'evil-surround-operator-alist '(evil-cp-delete . delete)))))
  :config
  (progn
    (setq evil-cross-lines t)
    (setq evil-move-cursor-back nil)
    (setq evil-default-state 'emacs)))

(use-package guide-key
  :init (guide-key-mode 1)
  :config
  (progn
    (setq guide-key/idle-delay 1)
    (setq guide-key/recursive-key-sequence-flag t)
    (setq guide-key/popup-window-position 'bottom)
    (setq guide-key/guide-key-sequence
          `("C-h" "C-x" "C-c" ,evil-leader/leader "g" "z"))))

(use-package ido
  :config
  (progn
    (evil-leader/set-key "bs" 'ido-switch-buffer)
    (evil-leader/set-key "bk" 'ido-kill-buffer)
    (evil-leader/set-key "ff" 'ido-find-file)))

(use-package flx-ido
  :init (flx-ido-mode 1)
  :config (setq ido-use-faces nil))

(use-package ido-vertical-mode
  :init (ido-vertical-mode 1))

(use-package fancy-narrow
  :config
  (evil-leader/set-key
    "nr" 'fancy-narrow-to-region
    "np" 'fancy-narrow-to-page
    "nf" 'fancy-narrow-to-defun
    "nw" 'fancy-widen))

(use-package projectile :init (projectile-global-mode))

(use-package yasnippet
  :init
  (progn
    (yas-global-mode 1)
    (use-package clojure-snippets)))

(use-package org
  :config
  (progn
    (setq org-tags-column 0)
    (defun wicked/org-clock-in-if-starting ()
      "Clock in when the task is marked STARTED."
      (when (and (string= state "STARTED")
                 (not (string= last-state state)))
        (org-clock-in)))
    (add-hook 'org-after-todo-state-change-hook
              'wicked/org-clock-in-if-starting)
    (defadvice org-clock-in (after wicked activate)
      "Set this task's status to 'STARTED'."
      (org-todo "STARTED"))
    (defun wicked/org-clock-out-if-waiting ()
      "Clock out when the task is marked WAITING."
      (when (and (string= state "WAITING")
                 (equal (marker-buffer org-clock-marker) (current-buffer))
                 (< (point) org-clock-marker)
                 (> (save-excursion (outline-next-heading) (point))
                    org-clock-marker)
                 (not (string= last-state state)))
        (org-clock-out)))
    (add-hook 'org-after-todo-state-change-hook
              'wicked/org-clock-out-if-waiting)))

(use-package yaml-mode
  :mode ("\\.yml$" . yaml-mode))

(use-package markdown-mode
  :mode (("\\.markdown$" . markdown-mode)
         ("\\.md$" . markdown-mode)))

(use-package glsl-mode)

(use-package clojure-mode
  :mode (("\\.edn$" . clojure-mode))
  :config
  (progn
    (define-clojure-indent
      (defroutes 'defun)
      (GET 2)
      (POST 2)
      (PUT 2)
      (DELETE 2)
      (HEAD 2)
      (ANY 2)
      (context 2)
      (let-routes 1))

    (define-clojure-indent
      (form-to 1))

    (define-clojure-indent
      (match 1)
      (are 2)
      (checking 2)
      (async 1))

    (define-clojure-indent
      (select 1)
      (insert 1)
      (update 1)
      (delete 1))

    (define-clojure-indent
      (run* 1)
      (fresh 1))

    (define-clojure-indent
      (extend-freeze 2)
      (extend-thaw 1))

    (define-clojure-indent
      (go-loop 1))

    (define-clojure-indent
      (this-as 1)
      (specify 1)
      (specify! 1))

    (setq clojure--prettify-symbols-alist
          '(("fn" . ?λ)))

    (defun toggle-nrepl-buffer ()
      "Toggle the nREPL REPL on and off"
      (interactive)
      (if (string-match "cider-repl" (buffer-name (current-buffer)))
          (delete-window)
        (cider-switch-to-repl-buffer)))

    (defun cider-save-and-refresh ()
      (interactive)
      (save-buffer)
      (call-interactively 'cider-refresh))

    (evil-leader/set-key "eb" 'cider-eval-buffer)
    (evil-leader/set-key "ee" 'cider-eval-last-sexp)
    (evil-leader/set-key "er" 'cider-eval-region)
    (evil-leader/set-key "ef" 'cider-eval-defun-at-point)

    (evil-leader/set-key "cd" 'cider-doc)
    (evil-leader/set-key "cc" 'cider-connect)
    (evil-leader/set-key "cj" 'cider-jack-in)
    (evil-leader/set-key "cJ" 'cider-jack-in-clojurescript)
    (evil-leader/set-key "ct" 'cider-test-run-ns-tests)
    (evil-leader/set-key "cT" 'cider-test-run-project-tests)
    (evil-leader/set-key "cn" 'cider-repl-set-ns)
    (evil-leader/set-key "cr" 'toggle-nrepl-buffer)
    (evil-leader/set-key "cf" 'cider-save-and-refresh)

    (global-set-key (kbd "s-r") 'cider-save-and-refresh)))

(use-package htmlize)

(use-package ox-reveal
  :defer t
  :init
  (progn
    (setq org-reveal-root (concat "file://" (emacs-d "vendor/reveal.js"))))
  :commands (org-reveal-export-to-html org-reveal-export-to-html-and-browse))

(use-package cider
  :init
  (progn
    (add-hook 'cider-repl-mode-hook #'subword-mode))
  :config
  (progn
    (setq nrepl-hide-special-buffers t)
    (setq cider-popup-stacktraces-in-repl t)
    (setq cider-repl-history-file "~/.emacs.d/nrepl-history")
    (setq cider-repl-pop-to-buffer-on-connect nil)
    (setq cider-repl-use-clojure-font-lock nil)
    (setq cider-auto-select-error-buffer nil)
    (setq cider-prompt-save-file-on-load nil)
    (setq cider-repl-display-help-banner nil)
    (setq cider-repl-display-in-current-window t)
    (setq cider-jack-in-lein-plugins '(("refactor-nrepl" "2.3.0-SNAPSHOT")
                                       ("cider/cider-nrepl" "0.15.0-SNAPSHOT")
                                       ("com.billpiel/sayid" "0.0.14")))))          
                                        ;    (setq cider-refresh-before-fn "reloaded.repl/suspend")
                                        ;    (setq cider-refresh-after-fn "reloaded.repl/resume")
                                        ;    (setq cider-cljs-lein-repl "(do (reloaded.repl/go) (user/cljs-repl))")

(use-package sayid
  :init
  (progn
    (add-hook 'clojure-mode-hook #'sayid-setup-package)))

(use-package typed-clojure-mode
  :init
  (add-hook 'clojure-mode-hook 'typed-clojure-mode)
  :config
  (progn
    (evil-leader/set-key "tc" 'typed-clojure-check-ns)))

(use-package clj-refactor
  :init
  (add-hook 'clojure-mode-hook (lambda () (clj-refactor-mode 1)))
  :config
  (progn
    (evil-leader/set-key "rai" 'cljr-add-import-to-ns)
    (evil-leader/set-key "rar" 'cljr-add-require-to-ns)
    (evil-leader/set-key "rau" 'cljr-add-use-to-ns)
    (evil-leader/set-key "rrr" 'cljr-remove-unused-requires)
    (evil-leader/set-key "rsn" 'cljr-sort-ns)
    (evil-leader/set-key "rtf" 'cljr-thread-first-all)
    (evil-leader/set-key "rtl" 'cljr-thread-last-all)
    (evil-leader/set-key "rcc" 'cljr-cycle-coll)
    (evil-leader/set-key "rcp" 'cljr-cycle-privacy)
    (evil-leader/set-key "rcs" 'clojure-toggle-keyword-string)
    (evil-leader/set-key "rfe" 'cljr-create-fn-from-example)))

(use-package docker)

(use-package dockerfile-mode
  :mode (("Dockerfile\\'" . dockerfile-mode)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 (custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  )
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
