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

(use-package general
  :config
  (general-evil-setup t)
  ;;(general-auto-unbind-keys)

  (general-create-definer rune/leader-keys
    :states '(normal visual motion emacs insert)
    :keymaps 'override
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
	;; (backup-directory-alist '((".*" . "~/.backups/")))
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
		"bk" 'kill-current-buffer
		"bm" 'buffer-menu
    "bi" 'recentf
    "r" 'switch-to-buffer
    "w" (general-simulate-key "C-w")
    "SPC" 'find-file)

  (general-define-key
   :states '(normal)
   :keymaps 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file
    "C-o" 'casual-dired-tmenu
    "q" 'kill-this-buffer
  )
  :diminish visual-line-mode
  :after general
)

(use-package avy
  :general
  (general-define-key
   :states '(insert normal motion visual)
   "C-f" 'avy-goto-char
   "C-t" 'avy-goto-char-timer)

  (rune/leader-keys
    "f" 'avy-goto-char)
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

(unless (package-installed-p 'editorconfig)
	(package-install 'editorconfig))

(use-package diminish
	:ensure t
)

(use-package imenu-list
	:config
	(imenu-list-focus-after-activation t)
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
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0.2)
  (corfu-popupinfo-delay '(0.4 . 0.2))
  (corfu-echo-documentation t)
  :init (global-corfu-mode)
  :hook (global-corfu-mode . corfu-popupinfo-mode)
	:diminish corfu-mode
)

(use-package cape
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press C-c p ? to for help.
  :bind ("C-c p" . cape-prefix-map) ;; Alternative keys: M-p, M-+, ...
  ;; Alternatively bind Cape commands individually.
  ;; :bind (("C-c p d" . cape-dabbrev)
  ;;        ("C-c p h" . cape-history)
  ;;        ("C-c p f" . cape-file)
  ;;        ...)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
  ;; ...
)

(use-package yasnippet-capf
  :ensure t
  :after cape)

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
  (elfeed-search-filter "")
	(elfeed-feeds
		'(("https://xeiaso.net/blog.rss" nix)
		 ("https://servo.org/blog/feed.xml" misc)
     ("https://blog.system76.com/rss.xml" misc)
		 ("https://ferd.ca/feed.rss" misc)
		 ("https://samoa.dcs.gla.ac.uk/events/rest/Feed/rss/123" research)
		 ("https://xkcd.com/rss.xml" misc)))
  :general
  (rune/leader-keys
    "e" #'(lambda () (interactive) (elfeed-update) (elfeed))
    )
  (general-define-key
   :keymaps 'eww-mode-map
   "C-y" 'eww-copy-page-url
   )
	:defer t
)

(use-package markdown-mode
	:defer t
	)

(use-package nix-mode
  :init
  (add-hook 'nix-mode-hook
    (lambda () (add-hook 'before-save-hook 'nix-format-buffer nil t)))
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
  (before-save-hook . #'org-agenda-sort-headers)
	)

(use-package org-auto-tangle
	:config
	(org-auto-tangle-default t)
	:ensure t
	:diminish org-auto-tangle-mode
	:hook
	(org-mode . org-auto-tangle-mode)
	)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
	 (emacs-lisp . t)
	 (haskell . t)
	 (java . t)
	 ))

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
  :custom
  (undo-tree-history-directory-alist '(("." . "~/.backups")))
	:ensure t
	:diminish undo-tree-mode
	:after evil)

(use-package vterm
	:ensure t)

(use-package vterm-toggle
  :init
	(keymap-global-set "s-<return>" 'vterm-toggle)
  :ensure t
  )
(keymap-global-set "s-c" 'calc)
(keymap-global-set "C-c C-c" 'compile)

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
	(add-hook 'pdf-view-mode-hook #'(lambda () (display-line-numbers-mode -1)))
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

(use-package gorepl-mode
  :hook
  (go-mode . gorepl-mode))

(use-package envrc
	:hook (after-init . envrc-global-mode))

(use-package ligature
  :config
  ;; Enable all Iosevka ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  :hook (prog-mode . ligature-mode)
  )

(use-package docker
  :ensure t
  :general
  (rune/leader-keys
		"d" 'docker)
  )

(use-package eglot
	:hook (prog-mode . eglot-ensure)
  :general
  (rune/leader-keys
   :keymaps 'prog-mode-map
   "lr" 'eglot-rename
  )
	:bind
	("M-RET" . eglot-code-actions)
	("M-r" . eglot-rename)
  :custom
  (gc-cons-threshold 100000000)
  (read-process-output-max (* 1024 1024)) ;; 1mb
  :config
    (setq-default eglot-workspace-configuration
		'((:gopls .
			  (
			    (staticcheck . t)
			    (completeUnimported          . t)
			    (usePlaceholders             . t)
			    (expandWorkspaceToModule     . t)
			    ))))
  :demand t
  :hook (eglot-managed-mode . (lambda ()
	  (setq-local completion-at-point-functions
		  (list (cape-capf-super
			   #'eglot-completion-at-point #'yasnippet-capf)))))
  :after yasnippet)

(use-package eldoc
	:init
	(global-eldoc-mode)
  :diminish eldoc-mode)

(use-package protobuf-mode)
(use-package yaml)

(use-package hotfuzz)

(use-package orderless
  :ensure t
  :after hotfuzz
  :custom
  (completion-styles '(hotfuzz orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))
