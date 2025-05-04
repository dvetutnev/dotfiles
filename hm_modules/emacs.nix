{ pkgs
, ...
}:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacs-unstable;
      config = ../init.el;
      defaultInitFile = true;
      extraEmacsPackages = epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
      ];
    };
  };
}
