{ pkgs, ... }:
{

  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "dvetutnev"
    "@wheel"
  ];

  time.timeZone = "Europe/Moscow";
  networking.hostName = "rpi5";
  users.users.dvetutnev = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFNlAOm+vdRwE4h877Y3CFz9CnmDzXaQ6aL5mw8WItUP dvetutnev@lynx"
    ];
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    nano
    gnome-tweaks
    dconf-editor
    gnome-terminal
    chromium
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  system.stateVersion = "25.05";

}
