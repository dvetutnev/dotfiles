 (use-package solarized-theme
  :ensure t)
(load-theme 'solarized-selenized-dark t)

(unless (display-graphic-p)
  (menu-bar-mode -1))

(when (display-graphic-p)
  (set-face-attribute 'default nil :height 120)
  (tool-bar-mode -1))

(use-package nix-mode
  :ensure t
  :defer t
  :mode "\\.nix\\'"
  :config (add-hook 'before-save-hook 'nix-format-before-save))

(use-package clojure-ts-mode
  :ensure t
  :defer t)

(use-package lua-mode
  :ensure t
  :defer t
  :mode "\\.lua\\'")

(use-package cider
  :ensure t
  :defer t)

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
