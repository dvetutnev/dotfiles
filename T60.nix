{ config
, lib
, pkgs
, nvim
, ... }:

{
  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim # or some other editor, e.g. nano or neovim
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes repl-flake
  '';

  # Set your time zone
  time.timeZone = "Europe/Moscow";

  home-manager = {
    useGlobalPkgs = true;
    #useUserPackages = true;
    extraSpecialArgs = { inherit nvim; };

    config = { config, pkgs, lib, ... }: {
      imports = [
        hm_modules/nvim.nix
      ];

      #programs.bash.enable = true;
      programs.git.enable = true;
      programs.ssh.enable = true;

      # Ahtung! Read HM changlog before editt
      home.stateVersion = "24.05";
    };
  };
}
