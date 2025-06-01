final: prev: {
  emacs-custom = prev.emacsWithPackagesFromUsePackage {
    package = prev.emacs-unstable;
    config = ./init.el;
    defaultInitFile = true;
    extraEmacsPackages =
      epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
      ];
  };
}
