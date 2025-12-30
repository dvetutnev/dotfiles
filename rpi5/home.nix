{ pkgs, ... }:
{
  imports = [
    ../hm_modules/git.nix
    ../hm_modules/bat.nix
    ../hm_modules/dircolors.nix
    ../hm_modules/misc.nix
    ../hm_modules/emacs.nix
    ../hm_modules/nixd.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    hackgen-nf-font
  ];

  home.username = "dvetutnev";
  home.homeDirectory = "/home/dvetutnev";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

}
