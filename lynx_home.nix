{ pkgs, ... }:

{
  imports = [
    hm_modules/nvim.nix
    hm_modules/git.nix
    hm_modules/bat.nix
    hm_modules/dircolors.nix
    hm_modules/misc.nix
    hm_modules/emacs.nix
    hm_modules/clojure.nix
    hm_modules/nixd.nix
    hm_modules/cmake-aliases.nix
    hm_modules/mitscheme.nix
  ];

  programs.bash.enable = true; # for env var and aliases
  services.syncthing.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    keepassxc
    google-chrome

    telegram-desktop
    wasistlos

    obsidian

    gnome-tweaks
    gnome-weather
    gnomeExtensions.weather-or-not
    gnomeExtensions.gnome-bedtime

    eog # Gnome image viewer
    wireguard-tools
    # fonts
    hackgen-nf-font
    source-code-pro

    qtcreator
  ];

  home.username = "dvetutnev";
  home.homeDirectory = "/home/dvetutnev";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
      };
      github = {
        hostname = "github.com";
        user = "git";
        identityFile = "/home/dvetutnev/.ssh/github.ed25519";
      };
      kysa = {
        hostname = "kysa.me";
        user = "dvetutnev";
        identityFile = "/home/dvetutnev/.ssh/nixos.vdsina";
      };
      wg-kysa = {
        hostname = "wg.kysa.me";
        user = "dvetutnev";
        identityFile = "/home/dvetutnev/.ssh/wg.kysa";
      };
      racknerd = {
        hostname = "192.227.172.249";
        user = "dvetutenv";
        identityFile = "/home/dvetutnev/.ssh/racknerd-c9b981";
      };
    };
  };

  home.shellAliases = {
    wgup = "sudo wg-quick up /home/dvetutnev/wg.kysa.me.conf";
    wgdown = "sudo wg-quick down /home/dvetutnev/wg.kysa.me.conf";
  };
}
