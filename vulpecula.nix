{ pkgs
, ...
}:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "dvetutnev";
  home.homeDirectory = "/home/dvetutnev";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  #programs.git.userName = pkgs.lib.mkForce "x";
  home.packages = [ pkgs.wireguard-tools ];

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
      pyxis = {
        hostname = "192.168.0.200";
        user = "user";
        identityFile = "/home/dvetutnev/.ssh/pyxis.ed25519";
      };
      racknerd = {
        hostname = "192.227.172.249";
        user = "dvetutenv";
        identityFile = "/home/dvetutev/.ssh/racknerd-c9b981";
      };
    };
  };

  programs.borgmatic = {
    enable = true;
    backups = {
      Sync = {
        location = {
          sourceDirectories = [ "/home/dvetutnev/Sync" ];
          #repositories = [ "/home/dvetutnev/Backup Sync" "ssh://dvetutnev@kysa.me/./Backup Sync"];
          repositories = [ "/home/dvetutnev/Backup Sync" ];
       };
        retention.keepDaily = 14;
      };
    };
  };
  services.borgmatic.enable = true;
}

