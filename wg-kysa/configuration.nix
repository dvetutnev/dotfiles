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
    hostName = "wg.kysa"; # Define your hostname.
    useDHCP = false;
    interfaces.ens3.ipv4.addresses = [
      {
        address = "144.124.252.154";
        prefixLength = 24;
      }
    ];
    defaultGateway = "144.124.252.1";
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
      "wheel"
      "docker"
    ]; # Enable ‘sudo’ for the user.
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

  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "ens3";
  networking.nat.internalInterfaces = [ "wg0" ];

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ens3 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ens3 -j MASQUERADE
      '';

      privateKey = "uMUdaPUM5d2AF9UbNKPH/e2EEHdFZC3VIDMxRn6CHHI=";

      peers = [
        # List of allowed peers.
        {
          # Feel free to give a meaning full name
          # Public key of the peer (not a file path).
          publicKey = "Ceu6BGh88do+xdNMHH0pE6YGkzXXXPA7G8GUvMK0hVA=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          publicKey = "evhkt5ajjtm9uLH2enPJ0mtSFsmD4YCtEmeK52PcESk=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    22 # ssh
    80 # http
    443 # https
    22000 # syncthing
  ];
  networking.firewall.allowedUDPPorts = [
    22000 # syncthing
    51820 # wireguard
  ];
  # From Docker container to MySQL on localhost
  networking.firewall.interfaces."docker0".allowedTCPPorts = [ 3306 ];

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
