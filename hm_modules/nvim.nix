{ nvim
, ...
}:

{
  home.packages = [ nvim ];
  home.sessionVariables = { EDITOR = "nvim"; };
  home.shellAliases = { vim = "nvim"; };
}

