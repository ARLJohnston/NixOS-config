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

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
;; (require 'use-package)
(require 'package)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("gnu-devel" . "https://elpa.gnu.org/devel/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

(use-package general
  :config
  (general-evil-setup t)
  (general-auto-unbind-keys)

  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
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
  (rune/leader-keys
		"bk" 'kill-this-buffer
		"bm" 'buffer-menu
    "r" 'recentf
    "bi" 'switch-to-buffer
    "w" (general-simulate-key "C-w")
  )

  (rune/leader-keys
   :keymaps 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file
    "C-o" 'casual-dired-tmenu
    "q" 'kill-this-buffer
  )
  :diminish visual-line-mode
  :after general
)

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-monokai-ristretto t)
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
  (rune/leader-keys
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
	(savehist-mode)
	:ensure t
)

(use-package corfu
  :ensure t
	:custom
	(corfu-cycle t)
	(corfu-auto t)
	;; (corfu-separator ?\s)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.2)
  (corfu-popupinfo-delay '(0.4 . 0.2))
  (corfu-echo-documentation t)
  :hook
  (
	  (after-init . global-corfu-mode)
	  (global-corfu-mode . corfu-popupinfo-mode)
  )
	:diminish corfu-mode
)

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  ;; (add-to-list 'completion-at-point-functions #'cape-sgml)
  )

(use-package yasnippet-capf
  :after cape
  ;; :custom
  ;; (yasnippet-capf-lookup-by 'name)
  :config
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package elfeed
	:custom
  (shr-max-image-proportion 0.5)
	(browse-url-browser-function 'eww-browse-url)
	(elfeed-feeds
		'(("https://xeiaso.net/blog.rss" nix)
		 ("https://servo.org/blog/feed.xml" mis)
		 ("https://ferd.ca/feed.rss" misc)
		 ("https://samoa.dcs.gla.ac.uk/events/rest/Feed/rss/123" research)
		 ("https://xkcd.com/rss.xml" misc)))
  :general
  (rune/leader-keys
    "e" 'elfeed
  )
	:defer t
)


(use-package markdown-mode
	:defer t
	)

(use-package eglot
	:hook (prog-mode . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '(gleam-mode . ("gleam" "lsp")))
  (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer")))
  :general
  (rune/leader-keys
   :keymaps 'prog-mode-map
   "lr" 'eglot-rename
  )
	:bind
	("M-RET" . eglot-code-actions)
  :demand t
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
  (yas-minor-mode-on)
	:bind
	("M-s" . yas-insert-snippet)
	:custom
	(yas-snippet-dirs '("~/config/emacs/snippets"))
	:ensure t
	:diminish yas-minor-mode
	)

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
  (rune/leader-keys
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

;; (use-package org-sticky-header-mode
;; 	:straight (:type git :host github :repo "alphapapa/org-sticky-header")
;; 	:init
;; 	(setq org-sticky-header-full-path 'full)
;; 	(setq org-sticky-header-outline-path-seperator " / ")
;; 	:hook
;; 	(org-mode . org-sticky-header-mode)
;; 	:defer t
;; )

;; (use-package org-superstar
;; 	:custom
;; 	(org-hide-leading-stars t)
;; 	(org-superstar-leading-bullet ?\s)
;; 	(org-indent-mode-turns-on-hiding-stars nil)
;; 	:hook
;; 	(org-mode-hook . org-superstar-mode)
;; 	:defer t
;; 	)

;; (use-package htmlize)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
	 (emacs-lisp . t)
	 (haskell . t)
	 (java . t)
	 ))

;; ;;(use-package org-roam
;; ;;	:init
;; ;;	(setq org-roam-directory "~/org")
;; ;;
;; ;;	(setq org-roam-capture-templates
;; ;;		'(("d" "default" plain
;; ;;			"%?"
;; ;;			:if-new (file+head "${slug}-%<%Y%m%d%H%M%S>.org"
;; ;;				"#+title: ${title}\n")
;; ;;			:unnarrowed t
;; ;;			:jump-to-captured t)
;; ;;		("m" "meeting" plain
;; ;;			"%?"
;; ;;			:if-new (file+head "${slug}-%<%Y%m%d%H%M%S>.org"
;; ;;				"=================\n** Meeting %U\nAttendees:\n")
;; ;;			:unnarrowed t
;; ;;			:jump-to-captured t)))
;; ;;)


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

;; (use-package dired-preview
;; 	:init
;; 	(dired-preview-global-mode 1)
;; 	)

(use-package zoxide
	:general
	(rune/leader-keys
    "." 'zoxide-travel-with-query)
	)

(use-package magit
	:ensure t
  :general
  (rune/leader-keys
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
  :mode ("\\.go?$" . go-mode)
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
