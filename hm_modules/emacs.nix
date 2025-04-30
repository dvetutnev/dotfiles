{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacs-unstable-nox;
      config = ../emacs.el;
    };
  };
}
