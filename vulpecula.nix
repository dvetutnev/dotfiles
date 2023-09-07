{ nixpkgs
, home-manager
, nixgl
}:

let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  mkNixGLWrapper = pkgs.callPackage ./mkNixGLWrapper.nix { };
  nixGLWrap = mkNixGLWrapper nixgl.packages.${system}.nixGLIntel;

  nvim = pkgs.callPackage ./nvim.nix { };

  home = {
    programs.git = {
      enable = true;
      userName = "Dmitriy Vetutnev";
      userEmail = "d.vetutnev@gmail.com";
      extraConfig = {
        merge.conflictstyle = "diff3";
      };
    };

    programs.bat = {
      enable = true;
      config = {
        theme = "Solarized (dark)";
      };
      extraPackages = with pkgs.bat-extras; [
        batdiff
      ];
    };

    programs.bash = {
      enable = true;
      bashrcExtra = ''
        detach()
        {
          nohup $1 >/dev/null 2>&1 &
        }
      '';
    };
    programs.dircolors.enable = true;
    home.shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      diff = "diff --color=auto";
      ip = "ip -color=auto";
    };

    home.packages = with pkgs; [
      (nixGLWrap qtcreator)
      (nixGLWrap mpv)
      (nixGLWrap tdesktop)
      (nixGLWrap google-chrome)
      nvim
      (nixGLWrap neovide)
      keepassxc
      obsidian
      minicom
      nmap
      cppcheck
      clang-tools_16
      cmake-format
      nixpkgs-fmt
      lsyncd
      jq
      curl
      tree
      wireguard-tools
      graphviz
      gnome.pomodoro
      hackgen-nf-font
    ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    fonts.fontconfig.enable = true;

    services.syncthing.enable = true;

    # Home Manager has an option to automatically set some environment variables
    # that will ease usage of software installed with nix on non-NixOS linux
    # (fixing local issues, settings XDG_DATA_DIRS, etc.):
    targets.genericLinux.enable = true;

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
  };
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    home
  ];
}
