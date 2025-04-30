{ config
, lib
, pkgs
, nvim
, ... }:

{
  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    # vim # or some other editor, e.g. nano or neovim
    which
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  terminal.colors = {
    background = "#002B36";
    foreground = "#839496";
  };

  # Set your time zone
  time.timeZone = "Europe/Moscow";

  home-manager = {
    extraSpecialArgs = { inherit nvim; };

    config = { config, pkgs, lib, ... }: {
      imports = [
        hm_modules/nvim.nix
        hm_modules/git.nix
        hm_modules/bat.nix
        hm_modules/dircolors.nix
        hm_modules/misc.nix
      ];

      programs.bash.enable = true;

      programs.ssh = {
        enable = true;
        package = pkgs.openssh;
        serverAliveInterval = 60;
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "/data/data/com.termux.nix/files/home/.ssh/github.ed25519";
            identitiesOnly = true;
          };
        };
      };

      # Ahtung! Read HM changlog before editt
      home.stateVersion = "24.05";
    };
  };
}
