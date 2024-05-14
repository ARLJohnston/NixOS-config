;;Install Straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
			 (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
			(bootstrap-version 6))
	(unless (file-exists-p bootstrap-file)
		(with-current-buffer
				(url-retrieve-synchronously
				 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
				 'silent 'inhibit-cookies)
			(goto-char (point-max))
			(eval-print-last-sexp)))
	(load bootstrap-file nil 'nomessage))

;; (straight-use-package 'use-package)
(require 'use-package)
(require 'general)

(use-package general
  :config
  (general-evil-setup t)
  ;; Unbind other uses if key if defined (e.g. unbind evil-forward-char from SPC)
  (general-auto-unbind-keys)
  :ensure t
  :demand t
)

(use-package emacs
	:custom
	(native-comp-speed 3)
	(ring-bell-function 'ignore)
	(initial-scratch-message 'nil)
;; Emacs 28 and newer: Hide commands in M-x which do not work in the current mode
	(read-extended-command-predicate #'command-completion-default-include-p)
	(backup-directory-alist '((".*" . "~/.backups/")))
;; Less Jumpy scrolling
	(scroll-step 1)
	(scroll-margin 4)
	(display-line-numbers-type 'relative)
	(default-tab-width 2)
	(warning-minimum-level :error)
	:init
	(add-to-list 'custom-theme-load-path "~/.emacs.d/everforest-emacs")
	(load-file "~/.emacs.d/everforest-emacs/everforest-hard-dark-theme.el")
	(load-theme 'everforest-hard-dark t)
	(set-face-attribute 'default nil :font "Iosevka Comfy")

	(tool-bar-mode -1)
	(menu-bar-mode -1)
	(scroll-bar-mode -1)
	(global-display-line-numbers-mode 1)
  (save-place-mode 1)
  (global-auto-revert-mode 1)
  (recentf-mode)
	(display-battery-mode)
  (setq global-auto-revert-non-file-buffers t)
	;;(electric-indent-mode -1)

	(winner-mode 1)
	(global-visual-line-mode)

	:bind
	("C-c h" . winner-undo)
	("C-c l" . winner-redo)
	("C-c c" . comment-or-uncomment-region)
	("C-c /" . comment-or-uncomment-region)

  :general
  (general-nmap
    :prefix "SPC"
		"bk" 'kill-this-buffer
		"bm" 'buffer-menu
    "r" 'recentf
  )
  :diminish visual-line-mode
)


(use-package whitespace
  :init
  (global-whitespace-mode)
  :custom
  (whitespace-display-mappings
   '(
	  (tab-mark ?\t [#x00B7 #x00B7])
	  (space-mark 32 [183] [46])
	  (space-mark 160 [164] [95])
    (newline-mark 10 [36 10])
    )
  )
  (whitespace-style
   '(
     empty
     face
     newline
     newline-mark
     space-mark
     spaces
     tab-mark
     tabs
     trailing
     )
  )
  :hook (before-save . whitespace-cleanup)
  :ensure nil
  :diminish whitespace-mode
)

(use-package casual-dired
	:straight (:type git :host github :repo "kickingvegas/casual-dired")
  :config
  (general-define-key
    :prefix "SPC"
    :keymaps 'dired-mode-map
   "o" 'casual-dired-tmenu
  )
)

(use-package bind-key
	:demand t)

(unless (package-installed-p 'editorconfig)
	(package-install 'editorconfig))

(use-package diminish
	:ensure t
)

(use-package imenu-list
	:init
	(setq imenu-list-focus-after-activation t)
  :general
  (general-nmap
    :prefix "SPC"
	"si" 'imenu-list-smart-toggle
  )
)

;;Better autocomplete
(use-package vertico
	:custom
	(vertico-count 13)
	(vertico-resize t)
	(vertico-cycle nil)
	(read-file-name-completion-ignore-case t)
	(read-buffer-completion-ignore-case t)
	(completion-ignore-case t)
	:config
	(vertico-mode)
	:ensure t
)

(use-package corfu
	;; Optional customizations
  :ensure t
	:custom
	(corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
	(corfu-auto t)                 ;; Enable auto completion
	(corfu-separator ?\s)          ;; Orderless field separator
	;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
	;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
	;; (corfu-preview-current nil)    ;; Disable current candidate preview
	;; (corfu-preselect 'prompt)      ;; Preselect the prompt
	;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
	;; (corfu-scroll-margin 5)        ;; Use scroll margin
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.2)
  (corfu-popupinfo-delay '(0.4 . 0.2))
  (corfu-echo-documentation t)
  (ispell-alternate-dictionary "/run/current-system/sw/lib/aspell/en-common.rws")
  :hook ((after-init . global-corfu-mode)
	  (global-corfu-mode . corfu-popupinfo-mode))
	:diminish corfu-mode
)

(use-package elfeed
	:custom
	(browse-url-browser-function 'eww-browse-url)
	(elfeed-feeds
		'(("https://xeiaso.net/blog.rss" nix)
		 ("https://servo.org/blog/feed.xml" mis)
		 ("https://ferd.ca/feed.rss" misc)
		 ("https://samoa.dcs.gla.ac.uk/events/rest/Feed/rss/123" research)
		 ("https://xkcd.com/rss.xml" misc)))
  :general
  (general-nmap
    :prefix "SPC"
   "e" 'elfeed
  )
	:defer t
)

(setq shr-max-image-proportion 0.5)

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
	:init
	(savehist-mode)
)

(use-package markdown-mode
	:defer t
	)

(use-package eglot
	:hook
  (
  (prog-mode . eglot-ensure)
  ((c-mode c++-mode go-mode java-mode js-mode python-mode rust-mode web-mode) . eglot-ensure)
  )
  :config
  (add-to-list 'eglot-server-programs '(gleam-mode . ("gleam" "lsp")))
  (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer")))
  :general
  (general-nmap
    :prefix "SPC"
    :keymaps 'prog-mode-map
   "lr" 'eglot-rename
  )
	:bind
	("M-RET" . eglot-code-actions)
  :demand t
)

;; Enable Corfu completion UI
;; See the Corfu README for more configuration tips.
(use-package corfu
  :init
  (global-corfu-mode)
)


(use-package eldoc
	:init
	(global-eldoc-mode))


(use-package nix-mode
	;;:hook
	;;(before-save . nix-mode-format)
	:defer t
)

(use-package yasnippet
	:init
	(yas-global-mode 1)
	:bind
	("M-s" . yas-insert-snippet)
	:custom
	(yas-snippet-dirs '("~/.emacs.d/snippets"))
	:ensure t
	:diminish yas-minor-mode
	)

(yas-minor-mode-on)

(use-package org
	:custom
	(org-src-preserve-indentation t)
	(org-todo-keywords
			'((sequence "TODO" "IN-PROGRESS" "DONE")))
	(org-clock-in-switch-to-state "IN-PROGRESS")

  (defun org-agenda-sort-at-point ()
	  (interactive)
	  (org-sort-entries nil ?o)
	  (org-sort-entries nil ?o))

  (defun org-agenda-sort-headers ()
    "Sort each header in the current buffer."
    (interactive)
    (org-map-entries (lambda () (org-sort-entries nil ?o)) nil 'tree))

  :general
  (general-nmap
    :prefix "SPC"
    :keymaps 'org-mode-map
		"co" 'org-clock-out
		"cu" 'org-clock-update-time-maybe
		"cs" 'org-agenda-sort-at-point
  )
	:ensure t
	:hook
  ;;(add-hook 'before-save-hook #'org-agenda-sort-headers)
	(org-mode . flyspell-mode)
	)

(use-package org-auto-tangle
	:init
	(setq org-auto-tangle-default t)
	:ensure t
	:diminish org-auto-tangle-mode
	:hook
	(org-mode . org-auto-tangle-mode)
	)

(use-package org-sticky-header-mode
	:straight (:type git :host github :repo "alphapapa/org-sticky-header")
	:init
	(setq org-sticky-header-full-path 'full)
	(setq org-sticky-header-outline-path-seperator " / ")
	:hook
	(org-mode . org-sticky-header-mode)
	:defer t
)

(use-package org-superstar
	:custom
	(org-hide-leading-stars t)
	(org-superstar-leading-bullet ?\s)
	(org-indent-mode-turns-on-hiding-stars nil)
	:hook
	(org-mode-hook . org-superstar-mode)
	:defer t
	)

(use-package htmlize)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
	 (emacs-lisp . t)
	 (haskell . t)
	 (java . t)
	 ))

;;(use-package org-roam
;;	:init
;;	(setq org-roam-directory "~/org")
;;
;;	(setq org-roam-capture-templates
;;		'(("d" "default" plain
;;			"%?"
;;			:if-new (file+head "${slug}-%<%Y%m%d%H%M%S>.org"
;;				"#+title: ${title}\n")
;;			:unnarrowed t
;;			:jump-to-captured t)
;;		("m" "meeting" plain
;;			"%?"
;;			:if-new (file+head "${slug}-%<%Y%m%d%H%M%S>.org"
;;				"=================\n** Meeting %U\nAttendees:\n")
;;			:unnarrowed t
;;			:jump-to-captured t)))
;;)


;;
(use-package marginalia
	:config
	(marginalia-mode 1)
	:ensure t
)

(use-package all-the-icons-completion
	:init
	(all-the-icons-completion-mode)
	:hook
	(marginalia-mode-hook . all-the-icons-completion-marginalia-setup)
)


(use-package evil
	:custom
  (with-eval-after-load 'dired
    (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
    (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-find-file))
	(evil-want-integration t)
	(evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
	:config
	(evil-mode 1)
	:hook
	(after-init . evil-mode)
	:ensure t
	)

(use-package evil-collection
	:config
	(evil-collection-init)
	:ensure t
	:diminish evil-collection-unimpaired-mode
  :after evil
	)

(use-package undo-tree
	:init
	(global-undo-tree-mode 1)
	(evil-set-undo-system 'undo-tree)
	(setq undo-tree-history-directory-alist '(("." . "~/.backups/")))
	(setq undo-tree-visualizer-timestamps t)
  (setq delete-old-versions t)
  (setq kept-new-versions 6)
  (setq kept-old-versions 2)
	:ensure t
	:diminish undo-tree-mode
	:after evil
	)

(use-package vterm
	:init
	(keymap-global-set "s-<return>" 'vterm-other-window)
	:defer t
	)
(keymap-global-set "s-c" 'calc)

(use-package dired-preview
	:init
	(dired-preview-global-mode 1)
	)

(use-package fzf
  :general
  (general-nmap
   :prefix "SPC"
   "bi" 'fzf-switch-buffer
  )
)

(use-package zoxide
	:general
	(general-nmap
    :prefix "SPC"
    "." 'zoxide-travel-with-query)
	)

(use-package magit
	:ensure t
  :general
  (general-nmap
    :prefix "SPC"
   "m" 'magit)
	)

(use-package pdf-tools
	:init
	(pdf-loader-install)
	(add-hook 'pdf-view-mode-hook '(lambda () (display-line-numbers-mode -1)))
	(add-hook 'pdf-view-mode-hook 'pdf-view-midnight-minor-mode)
	(add-hook 'pdf-mode-hook #'(lambda () (interactive) (display-line-numbers-mode -1)))
	:defer t
	)

(use-package go-mode
	:custom
	(compile-command "go test -v")
	:hook
	(before-save . gofmt-before-save)
	:defer t
	)

(use-package lsp-haskell
	:defer t
	)

(use-package haskell-mode
	:init
	(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
	:defer t
	)

(use-package envrc
	:hook (after-init . envrc-global-mode))

(use-package erlang
	:defer t
  :mode ("\\.erl?$" . erlang-mode)
)

(use-package rustic
  :ensure t
  :mode ("\\.rs?$" . rustic-mode)
  :config
  (setq rustic-format-on-save t)
  (setq rustic-lsp-client 'eglot))

(use-package tree-sitter-indent)

(use-package gleam-mode
  :load-path "~/.emacs.d/gleam-mode"
  :mode "\\.gleam\\'"
  )
