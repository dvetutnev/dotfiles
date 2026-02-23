{
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.mitscheme
    pkgs.racket
  ];
}
