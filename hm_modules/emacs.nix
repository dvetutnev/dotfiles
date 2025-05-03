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
    };
  };
}
