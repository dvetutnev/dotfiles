{ nvim
, ...
}:

{
  home.packages = [ nvim ];
  home.shellAliases = { vim = "nvim"; };
}

