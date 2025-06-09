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

(when (display-graphic-p)
  (set-face-attribute 'default nil :height 120)
  (tool-bar-mode -1))

(use-package flycheck
  :ensure t
  :defer t)

(use-package lsp-mode
  :ensure t
  :init (setq lsp-format-buffer-on-save t))

(use-package nix-mode
  :after lsp-mode
  :ensure t
  :defer t
  :mode "\\.nix\\'"
  :hook (nix-mode . lsp-deferred)
  :config (setq lsp-nix-nixd-server-path "nixd"
		lsp-nix-nixd-formatting-command [ "nixfmt" ]))

(use-package clojure-ts-mode
  :ensure t
  :defer t)

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

(use-package pandoc-mode
  :ensure t
  :defer t)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package markdown-ts-mode
  :ensure t
  :mode "\\.md\\'"
  :defer t)

(use-package vterm
  :ensure t
  :defer t)
