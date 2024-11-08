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

(use-package org
	:custom
	(org-return-follows-link t))

(use-package general
  :config
  (general-evil-setup t)
  (general-auto-unbind-keys)

  (general-create-definer rune/leader-keys
		:states '(normal visual motion emacs insert)
		:keymaps 'override
		:prefix "SPC"
		:global-prefix "C-SPC")
  :ensure t
  :demand t)

(use-package emacs
	:custom
	(native-comp-speed 3)
	(ring-bell-function 'ignore)
	(initial-scratch-message 'nil)
	(read-extended-command-predicate #'command-completion-default-include-p)
	(scroll-step 1)
	(scroll-margin 4)
	(display-line-numbers-type 'relative)
	(default-tab-width 2)
	(warning-minimum-level :error)
  (default-frame-alist '((undecorated . t)))
  (text-mode-ispell-word-completion nil)
	:init
	(tool-bar-mode -1)
	(menu-bar-mode -1)
	(scroll-bar-mode -1)
	(global-display-line-numbers-mode 1)
	(global-auto-revert-mode 1)
  (save-place-mode 1)
  (global-auto-revert-mode 1)
  (recentf-mode)
	(display-battery-mode)
  (setq global-auto-revert-non-file-buffers t)
	;;(electric-indent-mode -1)
	(setq backup-directory-alist '(("." . "~/.backups"))
				backup-by-copying t    ; Don't delink hardlinks
				version-control t      ; Use version numbers on backups
				delete-old-versions t  ; Automatically delete excess backups
				kept-new-versions 20   ; how many of the newest versions to keep
				kept-old-versions 5    ; and how many of the old
				)

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
		"s" 'project-switch-to-buffer
		"a" 'project-async-shell-command
		"w" (general-simulate-key "C-w")
		"oa" 'org-agenda
		"SPC" 'find-file
		"ni" 'org-roam-node-insert
		"ou" 'org-roam-ui-open
		"co" 'org-clock-out
		"cl" 'org-clock-in-last
		"or" #'(lambda () (interactive) (find-file "~/org/main.org"))
		)

  (general-define-key
   :states '(normal)
   :keymaps 'dired-mode-map
   "h" 'dired-up-directory
   "l" 'dired-find-file
   "q" 'kill-this-buffer
   )

  (general-define-key
   :states '(visual)
   "u" 'undo
   "r" 'undo-fu-only-redo
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

  (general-define-key
   :states '(normal motion visual)
   "s" 'avy-goto-char)

  (rune/leader-keys
		"f" 'avy-goto-char)
  )

(use-package doom-themes
	)
;;   :ensure t
;;   :config
;;   (load-theme 'doom-monokai-ristretto t))

(use-package ef-themes
	:config (load-theme 'ef-autumn t))

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
  :diminish
	)


(unless (package-installed-p 'editorconfig)
	(package-install 'editorconfig))

(use-package diminish
	:ensure t
	)

(use-package dockerfile-ts-mode
	:ensure nil
  :mode ((rx "Dockerfile" string-end) . dockerfile-ts-mode))

(use-package yaml-ts-mode
	:ensure nil
  :mode ((rx "yaml" string-end) . yaml-ts-mode)
((rx "yml" string-end) . yaml-ts-mode))

(use-package imenu-list
	;; :config
	;; (imenu-list-focus-after-activation t)
  ;; :general
  ;; (rune/leader-keys
	;; "si" 'imenu-list-smart-toggle
  ;; )
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
	;; https://github.com/minad/corfu/issues/108
	(corfu-on-exact-match nil)
  :init (global-corfu-mode)
  :hook (global-corfu-mode . corfu-popupinfo-mode)
	:diminish corfu-mode)

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :init
  (setq cape-dict-file "~/config/emacs/dictionary.dic")

  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  ;;(add-hook 'completion-at-point-functions #'cape-dict)
	(add-hook 'completion-at-point-functions #'org-roam-complete-everywhere)
	(add-hook 'completion-at-point-functions #'org-roam-complete-link-at-point)
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
	 '(("https://xeiaso.net/blog.rss" code)
     ("https://fly.io/blog/feed.xml" code)
		 ("https://servo.org/blog/feed.xml" misc)
     ("https://protesilaos.com/codelog.xml" emacs)
		 ("https://karthinks.com/index.xml" emacs)
     ("https://blog.system76.com/rss.xml" misc)
		 ("https://ferd.ca/feed.rss" misc)
		 ("https://threedots.tech/index.xml" code)
		 ("https://samoa.dcs.gla.ac.uk/events/rest/Feed/rss/123" research)
		 ("https://xkcd.com/rss.xml" misc)))
  :general
  (rune/leader-keys
		"e" #'(lambda () (interactive) (elfeed-update) (elfeed))
		)
  (rune/leader-keys
		:keymaps 'eww-mode-map
		"y" 'eww-copy-page-url
		)
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

(use-package org-roam-ui)
(use-package org-roam-bibtex
  :straight t
  :after org-roam)

;; (use-package org-auto-tangle
;; 	:ensure t
;; 	:diminish org-auto-tangle-mode
;; 	:hook
;; 	(org-mode . org-auto-tangle-mode)
;; 	)

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/org")
  (org-roam-complete-everywhere t)
  (org-agenda-files (list "~/org/"))
  (org-roam-capture-templates
   '(
     ("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)

		 ("m" "mermaid" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n #+STARTUP: inlineimages\n\n #+begin_src mermaid :file ${slug}.png\n flowchart TD\n A[Christmas] -->|Get money| B(Go shopping)\n B --> C{Let me think}\n C -->|One| D[Laptop]\n C -->|Two| E[iPhone]\n C -->|Three| F[fa:fa-car Car]\n #+end_src")
      :unnarrowed t)
     )
   )
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup)
  :general
  (rune/leader-keys
		:keymaps 'org-mode-map
		"ci" 'org-clock-in
		"cu" 'org-clock-update-time-maybe
		"nf" 'org-roam-node-find
		"nt" 'org-roam-buffer-toggle
		)
	)

(use-package ob-mermaid
  :straight t)

(use-package ob-latex-as-png
  :straight t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
	 (emacs-lisp . t)
	 (haskell . t)
   (mermaid . t)
	 (java . t)
   (latex . t)
	 ))
(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

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

(use-package undo-fu
  :init
  (setq undo-limit 67108864)
  (setq undo-strong-limit 100663296)
  (setq undo-outer-limit 1006632960))

(use-package undo-fu-session
  :ensure t
  :custom
  (undo-fu-session-directory "~/.backups")
  :init
  (undo-fu-session-global-mode))

(use-package vundo)

(use-package evil
	:custom
	(evil-want-integration t)
	(evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-undo-system 'undo-fu)
	:config
	(evil-mode 1)
	:hook
	(after-init . evil-mode)
	:ensure t
	)

;; https://emacs.stackexchange.com/a/46377
(with-eval-after-load 'evil-maps
	(define-key evil-motion-state-map (kbd "RET") nil))

(use-package evil-collection
	:config
	(evil-collection-init)
	:ensure t
	:diminish evil-collection-unimpaired-mode
  :after evil
	)

;; Use nix to install as don't want CMake
(use-package vterm
	:ensure t)

(use-package vterm-toggle
  :ensure t)

(keymap-global-set "s-<return>" 'vterm-toggle)
(keymap-global-set "s-c" 'calc)
(keymap-global-set "C-c C-c" 'project-compile)

(use-package magit
	:ensure t
  :general
  (rune/leader-keys
		"m" 'magit-status)
	)

(use-package pdf-tools
	:init
	(pdf-loader-install)
	(add-hook 'pdf-view-mode-hook #'(lambda () (display-line-numbers-mode -1)))
	(add-hook 'pdf-view-mode-hook 'pdf-view-midnight-minor-mode)
	(add-hook 'pdf-mode-hook #'(lambda () (interactive) (display-line-numbers-mode -1)))
	:defer t
	)


(use-package envrc
  :ensure t
	:hook (after-init . envrc-global-mode))

(use-package eglot
	:hook
  (prog-mode . eglot-ensure)
  (yaml-ts-mode . eglot-ensure)
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
  (eglot-autoshutdown t) ; shutdown after closing the last managed buffer
  (eglot-sync-connect 0) ; async, do not block
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

(use-package docker
  :ensure t
  :general
  (rune/leader-keys
		"d" 'docker))

(use-package transient
  :ensure t
  :init
  (transient-define-prefix go-transient ()
    [
     ("t" "Tidy"
      (lambda ()
        (interactive)
        (async-shell-command "go mod tidy")))

     ("v" "Vet"
      (lambda ()
				(interactive)
				(async-shell-command "go vet")))

     ("d" "Delve"
      (lambda ()
				(interactive)
				(dlv)))

     ("D" "Doc"
      (lambda ()
				(interactive)
				(godoc)))

     ("s" "Package Search"
      (lambda ()
				(interactive)
				(other-window-prefix)
	      (eww (concat '"https://pkg.go.dev/search?q=" (read-string "Enter Package Name:"))))
      )
     ])
  :general
  (rune/leader-keys
		"g" #'(lambda () (interactive) (go-transient))))


(add-to-list 'default-frame-alist
             '(font . "MonoLisa Nerd Font-10"))

(set-face-attribute 'default nil
                    :family "MonoLisa Nerd Font"
                    ;; :height 200
                    :weight 'normal
                    :width 'condensed)

(use-package org-alert
  :ensure t
	:custom
	(alert-default-style 'libnotify)
  (org-alert-interval 300)
  (org-alert-notify-cutoff 10)
  (org-alert-notify-after-event-cutoff 10))
(org-alert-enable)

(use-package jinx
	:init
	(global-jinx-mode)
  :general
  (general-define-key
   "C-;" 'jinx-correct-nearest)
	:diminish)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))


(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                 ,@(when-let ((depth (plist-get order :depth)))
                                                     (list (format "--depth=%d" depth) "--no-single-branch"))
                                                 ,(plist-get order :repo) ,repo))))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable use-package :ensure support for Elpaca
  (elpaca-use-package-mode))

(elpaca-wait)

(use-package p4-16-mode)

(use-package parrot
	:general
	(rune/leader-keys
		"pr" 'parrot-rotate-next-word-at-point))

(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode '("-->" "->" "->>" "-<" "--<"
                                       "-~" "]#" ".-" "!=" "!=="
                                       "#(" "#{" "#[" "#_" "#_("
                                       "/=" "/==" "|||" "||" ; "|"
                                       "==" "===" "==>" "=>" "=>>"
                                       "=<<" "=/" ">-" ">->" ">="
                                       ">=>" "<-" "<--" "<->" "<-<"
                                       "<!--" "<|" "<||" "<|||"
                                       "<|>" "<=" "<==" "<==>" "<=>"
                                       "<=<" "<<-" "<<=" "<~" "<~>"
                                       "<~~" "~-" "~@" "~=" "~>"
                                       "~~" "~~>" ".=" "..=" "---"
                                       "{|" "[|" ".."  "..."  "..<"
                                       ".?"  "::" ":::" "::=" ":="
                                       ":>" ":<" ";;" "!!"  "!!."
                                       "!!!"  "?."  "?:" "??"  "?="
                                       "**" "***" "*>" "*/" "#:"
                                       "#!"  "#?"  "##" "###" "####"
                                       "#=" "/*" "/>" "//" "///"
                                       "&&" "|}" "|]" "$>" "++"
                                       "+++" "+>" "=:=" "=!=" ">:"
                                       ">>" ">>>" "<:" "<*" "<*>"
                                       "<$" "<$>" "<+" "<+>" "<>"
                                       "<<" "<<<" "</" "</>" "^="
                                       "%%" "'''" "\"\"\"" ))

  (ligature-set-ligatures 'org-mode '("=>"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(use-package hl-todo
	:hook (elpaca-after-init . global-hl-todo-mode)
	:diminish)

(use-package haskell-mode
  :mode ("\\.hs?$" . haskell-mode))

(use-package protobuf-ts-mode
  :mode ("\\.proto?$" . protobuf-ts-mode))

(use-package go-mode
  :mode ("\\.go?$" . go-mode)
	:hook (before-save . gofmt-before-save))

(use-package indent-bars
  :ensure (indent-bars :host github :repo "jdtsmith/indent-bars")
  :hook (prog-mode . indent-bars-mode)
  :custom
	;; (indent-bars-treesit-support t)
  (indent-bars-prefer-character nil)
	(default-tab-width 2)
	(tab-width 2)
  (indent-bars-width-frac 0.1))

(use-package magit-todos
  :after magit
	:hook (elpaca-after-init . magit-todos-mode)
	:diminish)

(use-package eldoc
	:hook (elpaca-after-init . global-eldoc-mode)
  :diminish eldoc-mode)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(flex orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package terraform-mode
  :ensure t)
