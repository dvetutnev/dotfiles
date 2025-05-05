(use-package solarized-theme
  :ensure t)
(load-theme 'solarized-selenized-dark t)

(unless (display-graphic-p)
  (menu-bar-mode -1))

(use-package nix-ts-mode
  :ensure t
  :mode "\\.nix\\'")

(use-package clojure-ts-mode
  :ensure t)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package vterm
  :ensure t)
