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
  ];

  programs.bash.enable = true; # for env var and aliases
  services.syncthing.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    keepassxc
    google-chrome
    tdesktop
    obsidian
    gnomeExtensions.gnome-bedtime
    gnomeExtensions.gsconnect
    eog # Gnome image viewer
    wireguard-tools
    whatsapp-for-linux
    pandoc # tmp
    # fonts
    hackgen-nf-font
    source-code-pro
  ];

  home.username = "dvetutnev";
  home.homeDirectory = "/home/dvetutnev";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    serverAliveInterval = 60;
    matchBlocks = {
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
      racknerd = {
        hostname = "192.227.172.249";
        user = "dvetutenv";
        identityFile = "/home/dvetutnev/.ssh/racknerd-c9b981";
      };
    };
  };
}
