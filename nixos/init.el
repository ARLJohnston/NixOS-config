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

;; If I uncomment the below then all packages will be evaluated on load because of nix/emacs things
;; (straight-use-package 'use-package)
;; (setq straight-use-package-by-default t)
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
    "SPC" 'find-file
    "f" 'avy-goto-char
  )

  (general-define-key
   :states '(insert normal motion visual)
   "C-f" 'avy-goto-char
   "C-t" 'avy-goto-char-timer
  )

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

(use-package avy)

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
  :hook
  (
	  (after-init . global-corfu-mode)
	  (global-corfu-mode . corfu-popupinfo-mode)
  )
	:diminish corfu-mode
)


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
    "e" '(lambda () (interactive) (elfeed-update) (elfeed))
  )
	:defer t
)


(use-package markdown-mode
	:defer t
	)
(use-package lsp-mode
  :ensure t
  :commands lsp
  :hook
  ((rust-mode . (lsp lsp-inlay-hints-mode))
   (go-mode . (lsp lsp-inlay-hints-mode))
   (kotlin-mode . lsp)
   (c++-mode . lsp)
   (lua-mode . lsp)
   (prog-mode . lsp)
   )
  :config
  (gc-cons-threshold 100000000)
  (read-process-output-max (* 1024 1024)) ;; 1mb
  :custom
  ;; cc-mode does not work well when following two settings are enabled.
  (lsp-enable-on-type-formatting nil)
  (lsp-enable-indentation nil)
  (lsp-diagnostics-provider :flymake)
  (lsp-headerline-breadcrumb-icons-enable t)
  (lsp-enable-snippet t)
  (lsp-auto-guess-root t)
  (lsp-idle-delay 0.1)
  (lsp-log-io t)
  (lsp-modeline-code-actions-enable nil)
  (lsp-completion-provider :none)
  (lsp-eldoc-render-all t)
  (lsp-ui-doc-mode 1)
  :bind
  (:map lsp-mode-map
		("C-c C-l" . lsp-execute-code-action)
		("C-c r" . lsp-rename))
  :config
  (add-hook 'c++-mode-hook '(lambda() (add-hook 'before-save-hook 'lsp-format-buffer t t))))

(use-package lsp-ui
  :ensure t
  :hook (lsp-mode-hook . lsp-ui-mode)
  :custom
  ;; doc
  (lsp-ui-doc-enable nil)
  ;; sideline
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics nil)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-show-hover nil)
  :init
  (defun toggle-lsp-ui-sideline ()
	(interactive)
	(if lsp-ui-sideline-show-hover
        (progn
          (setq lsp-ui-sideline-show-hover nil
				lsp-ui-sideline-show-code-actions nil
				lsp-ui-sideline-show-diagnostics nil)
          (message "sideline-hover disabled"))
      (progn
        (setq lsp-ui-sideline-show-hover t
			  lsp-ui-sideline-show-code-actions t
			  lsp-ui-sideline-show-diagnostics t)
        (message "sideline-hover enabled"))))
  (defun toggle-lsp-ui-imenu ()
    (interactive)
	(let ((imenu-buffer (get-buffer lsp-ui-imenu-buffer-name)))
	  (if imenu-buffer
		  (progn
			(lsp-ui-imenu-buffer-mode -1)
			(kill-buffer lsp-ui-imenu-buffer-name)
			(message "lsp-ui-imenu disabled"))
		(progn
		  (lsp-ui-imenu)
		  (message "lsp-ui-imenu enabled")))))
  :bind
  (:map lsp-mode-map
		("C-c C-i" . lsp-ui-peek-find-implementation)
		("M-." . lsp-ui-peek-find-definitions)
		("M-?" . lsp-ui-peek-find-references)
		("C-c i" . toggle-lsp-ui-imenu)
		("C-c C-s" . toggle-lsp-ui-sideline)))


(use-package lsp-treemacs
  :ensure t
  :after lsp-mode)

(use-package sideline)

(use-package sideline-flymake
  :hook (flymake-mode . sideline-mode)
  :init
  (setq sideline-flymake-display-mode 'point) ; 'point to show errors only on point
                                              ; 'line to show errors on the current line
  (setq sideline-backends-right '(sideline-flymake)))


;; (use-package eglot
;; 	:hook (prog-mode . eglot-ensure)
;;   :config
;;   (add-to-list 'eglot-server-programs '(gleam-mode . ("gleam" "lsp")))
;;   (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer")))
;;   :general
;;   (rune/leader-keys
;;    :keymaps 'prog-mode-map
;;    "lr" 'eglot-rename
;;   )
;; 	:bind
;; 	("M-RET" . eglot-code-actions)
;;   :demand t
;; )

;; (use-package eldoc
;; 	:init
;; 	(global-eldoc-mode))

(use-package nix-mode
	;;:hook
	;;(before-save . nix-mode-format)
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

(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages))
  :general
  (general-define-key
   "C-;" 'jinx-correct)
  :diminish jinx-mode
  )

(use-package undo-tree
	:init
	(global-undo-tree-mode 1)
	(evil-set-undo-system 'undo-tree)
  :config
	;;(undo-history-directory-alist '(("." . "~/.backups/")))
  (delete-old-versions t)
  (kept-new-versions 6)
  (kept-old-versions 2)
  :custom
  (undo-tree-history-directory-alist '(("." . "~/.backups")))
	:ensure t
	:diminish undo-tree-mode
	:after evil
	)

(use-package vterm
	:ensure t
	)
(use-package vterm-toggle
  :init
	(keymap-global-set "s-<return>" 'vterm-toggle)
  :ensure t
  )
(keymap-global-set "s-c" 'calc)

(use-package toggle-term
  :bind (("M-o f" . toggle-term-find)
         ("M-o t" . toggle-term-term)
         ("M-o s" . toggle-term-shell)
         ("M-o e" . toggle-term-eshell)
         ("M-o i" . toggle-term-ielm)
         ("M-o o" . toggle-term-toggle))
  :config
    (setq toggle-term-size 25)
    (setq toggle-term-switch-upon-toggle t))

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

(use-package erlang)

(use-package erlang-mode
	:defer t
  :mode ("\\.erl?$" . erlang-mode)
)

(use-package rustic
  :defer t
  :mode ("\\.rs?$" . rustic-mode)
  :config
  (rustic-format-on-save t))

(use-package tree-sitter-indent)

(add-to-list 'load-path "~/.emacs.d/gleam-mode")
(load-library "gleam-mode")

;; (defun gleam-format-before-save ()
;;   (interactive)
;;   (when (eq major-mode 'gleam-mode) (gleam-format))
;;   )
(add-hook 'gleam-mode-hook
          (lambda () (add-hook 'before-save-hook 'gleam-format nil t)))

;; (add-hook 'before-save-hook 'gleam-format-before-save)

;; (use-package exwm
;;   :init
;; (start-process-shell-command "xmodmap" nil "xmodmap ~/.emacs.d/exwm/Xmodmap")
;;   :config
;;   ;; Set the default number of workspaces
;;   (setq exwm-workspace-number 5)

;;   ;; When window "class" updates, use it to set the buffer name
;;   ;; (add-hook 'exwm-update-class-hook #'efs/exwm-update-class)

;;   ;; These keys should always pass through to Emacs
;;   (setq exwm-input-prefix-keys
;;     '(?\C-x
;;       ?\C-u
;;       ?\C-h
;;       ?\M-x
;;       ?\M-`
;;       ?\M-&
;;       ?\M-:
;;       ?\C-\M-j  ;; Buffer list
;;       ?\C-\ ))  ;; Ctrl+Space

;;   ;; Ctrl+Q will enable the next key to be sent directly
;;   (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

;;   ;; Set up global key bindings.  These always work, no matter the input state!
;;   ;; Keep in mind that changing this list after EXWM initializes has no effect.
;;   (setq exwm-input-global-keys
;;         `(
;;           ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
;;           ([?\s-r] . exwm-reset)

;;           ;; Move between windows
;;           ([s-left] . windmove-left)
;;           ([s-right] . windmove-right)
;;           ([s-up] . windmove-up)
;;           ([s-down] . windmove-down)

;;           ;; Launch applications via shell command
;;           ([?\s-&] . (lambda (command)
;;                        (interactive (list (read-shell-command "$ ")))
;;                        (start-process-shell-command command nil command)))

;;           ;; Switch workspace
;;           ([?\s-w] . exwm-workspace-switch)

;;           ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
;;           ,@(mapcar (lambda (i)
;;                       `(,(kbd (format "s-%d" i)) .
;;                         (lambda ()
;;                           (interactive)
;;                           (exwm-workspace-switch-create ,i))))
;;                     (number-sequence 0 9))))

;;   (exwm-enable))

(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

(use-package ligature
  :config
  ;; Enable all Iosevka ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))
