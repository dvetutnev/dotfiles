{ nixpkgs
, nixvim
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

    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-lastplace
        vim-which-key
        vim-better-whitespace
      ];
      extraConfig = ''
        " your custom vimrc
        set nocompatible
        set backspace=indent,eol,start
        " Turn on syntax highlighting by default
        syntax on
        " Tab key & indent
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set smarttab
        set smartindent
        " Show tabs
        set list
        set listchars=tab:>-
        " whichkey
        set timeoutlen=500
        let g:mapleader = "\<Space>"
        let g:maplocalleader = ','
        nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
        nnoremap <silent> <localleader> :<c-u>WhichKey ','<CR>
        " ...
      '';
    };

    home.packages = with pkgs; [
      (nixGLWrap qtcreator)
      (nixGLWrap mpv)
      (nixGLWrap tdesktop)
      (nixGLWrap google-chrome)
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
    ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

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
    nixvim.homeManagerModules.nixvim
    ./nixvim.nix
    home
  ];
}

