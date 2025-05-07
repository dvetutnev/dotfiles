{ pkgs
, ...
}:

let
  emacs = pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacs-unstable;
      config = ../init.el;
      defaultInitFile = true;
      extraEmacsPackages = epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
      ];
  };
in
{
  home.packages = [ emacs ];
  home.sessionVariables = { EDITOR = "emacs"; };
  home.shellAliases = { em = "emacs"; };
}
