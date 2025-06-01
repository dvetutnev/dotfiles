{
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.emacs-custom ];
  home.sessionVariables = {
    EDITOR = "emacs";
  };
  home.shellAliases = {
    em = "emacs";
  };
}
