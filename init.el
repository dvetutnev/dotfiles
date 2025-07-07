(use-package solarized-theme
  :ensure t)
(load-theme 'solarized-selenized-dark t)

(unless (display-graphic-p)
  (menu-bar-mode -1))

(use-package all-the-icons
  :ensure t
  :defer t)

(fset 'yes-or-no-p 'y-or-n-p)
(setq-default frame-title-format "%b (%f)")
(setq make-backup-files nil)
(global-set-key (kbd "M-o") 'other-window)

(when (display-graphic-p)
  (set-face-attribute 'default nil :height 130)
  (set-face-attribute 'default nil :font "HackGen Console NF")
  (tool-bar-mode -1))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(save-place-mode t)

(use-package rainbow-delimiters
  :ensure t
  :hook prog-mode)

(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode
	  eval-expression-minibuffer-setup
	  ielm-mode
	  lisp-mode
	  lisp-interaction-mode
	  scheme-mode
	  clojure-mode
	  cider-repl-mode) . paredit-mode))

(use-package helm
  :ensure t
  :defer t)


(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(ido-mode t)

(require 'bookmark)
(require 'ido)

(defun ido-bookmark-jump ()
  "Uses ido to search for the bookmark"
  (interactive)
  (bookmark-jump
   (bookmark-get-bookmark
    (ido-completing-read "find bookmark: " (bookmark-all-names)))))

(provide 'ido-bookmark-jump)

(define-key (current-global-map) [remap bookmark-jump] 'ido-bookmark-jump)


(use-package flycheck
  :ensure t
  :defer t)

(use-package lsp-mode
  :ensure t
  :init (setq lsp-format-buffer-on-save t
	      lsp-keymap-prefix "C-c l"))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package nix-mode
  :after lsp-mode
  :ensure t
  :defer t
  :mode "\\.nix\\'"
  :hook (nix-mode . lsp-deferred)
  :config (setq lsp-nix-nixd-server-path "nixd"
		lsp-nix-nixd-formatting-command [ "nixfmt" ]))

(use-package clojure-mode
  :after lsp-mode
  :ensure t
  :defer t
  :mode "\\.clj\\'"
  :hook (clojure-mode . lsp-deferred))

(use-package cider
  :ensure t
  :defer t)

(use-package lua-mode
  :ensure t
  :defer t
  :mode "\\.lua\\'")

(use-package magit
  :ensure t
  :defer t)

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'"
  :defer t)

(use-package vterm
  :ensure t
  :defer t)
