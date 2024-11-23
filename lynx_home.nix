{
  home.username = "dvetutnev";
  home.homeDirectory = "/home/dvetutnev";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Dmitriy Vetutnev";
    userEmail = "d.vetutnev@gmail.com";
  };
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
        identityFile = "/home/dvetutev/.ssh/racknerd-c9b981";
      };
    };
  };
}

