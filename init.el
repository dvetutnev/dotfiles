(use-package solarized-theme
  :ensure t)
(load-theme 'solarized-selenized-dark t)

(unless (display-graphic-p)
  (menu-bar-mode -1))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package vterm
  :ensure t)
