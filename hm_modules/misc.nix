{ pkgs
, ...
}:

{
  home.packages = with pkgs; [
    file
    tree
    curl
    gawk
  ];
}
