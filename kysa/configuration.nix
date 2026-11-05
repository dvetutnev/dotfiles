# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  blog,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  time.timeZone = "Europe/Moscow";

  networking = {
    hostName = "kysa"; # Define your hostname.
    useDHCP = false;
    interfaces.ens3.ipv4.addresses = [
      {
        address = "185.209.28.178";
        prefixLength = 24;
      }
    ];
    defaultGateway = "185.209.28.1";
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dvetutnev = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHYlIR9XX2nZ8TX3c3e/al7Dnq4z9WZhy7XU4HMy9gPx dvetutnev"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    bat-extras.batdiff
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "yes";
    };
  };

  # Frontend Nginx
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "d.vetutnev@gmail.com";
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "kysa.me" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = blog.packages.${pkgs.system}.default;
        };
      };
    };
  };

  services.syncthing = {
    enable = true;
    user = "dvetutnev";
    dataDir = "/home/dvetutnev/Sync";
    configDir = "/home/dvetutnev/.config/syncthing";
  };

  services.fail2ban.enable = true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    22 # ssh
    80 # http
    443 # https
    22000 # syncthing
  ];
  networking.firewall.allowedUDPPorts = [
    22000 # syncthing
  ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
