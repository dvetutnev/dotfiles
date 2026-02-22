{
  pkgs,
  ...
}:

let
  emacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs-unstable;
    config = ../init.el;
    defaultInitFile = true;
    extraEmacsPackages =
      epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
        #(treesit-grammars.with-grammars (grammars: [ grammars.tree-sitter-scheme ]))
      ];
  };
in
{
  home.packages = [ emacs ];
  home.sessionVariables = {
    EDITOR = "emacs";
  };
  home.shellAliases = {
    em = "emacs";
  };
}
