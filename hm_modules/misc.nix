{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    file
    tree
    curl
    gawk
    nixfmt-rfc-style
    jq
    xxd
  ];
}
