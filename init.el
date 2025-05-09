(use-package solarized-theme
  :ensure t)
(load-theme 'solarized-selenized-dark t)

(unless (display-graphic-p)
  (menu-bar-mode -1))

(if (display-graphic-p)
  (set-face-attribute 'default nil :height 120))

(use-package nix-mode
  :ensure t)
(use-package nix-ts-mode
  :ensure t
  :mode "\\.nix\\'")

(use-package clojure-ts-mode
  :ensure t)

(use-package cider
  :ensure t)

(use-package magit
  :ensure t)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package markdown-ts-mode
  :ensure t
  :mode "\\.md\\'")

(use-package vterm
  :ensure t)
