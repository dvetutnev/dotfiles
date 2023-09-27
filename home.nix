{ config
, pkgs
, nixGLWrap
, nvim
, ...
}:

{
  config = {
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
      initExtra = ''
        # Provide a nice prompt if the terminal supports it.
        if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
          PROMPT_COLOR="1;31m"
          DIR_COLOR="1;34m"
          ((UID)) && PROMPT_COLOR="1;32m"
          if [ -n "$INSIDE_EMACS" ] || [ "$TERM" = "eterm" ] || [ "$TERM" = "eterm-color" ]; then
            # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
            PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
          else
            PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\[\033[$DIR_COLOR\]\w\[\033[$PROMPT_COLOR\]]\[\033[0m\]\$ "
          fi
          if test "$TERM" = "xterm"; then
            PS1="\[\033]2;\h:\u:\w\007\]$PS1"
          fi
        fi
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

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.packages = with pkgs; [
      nvim
      (nixGLWrap neovide)
      (nixGLWrap qtcreator)
      (nixGLWrap mpv)
      (nixGLWrap tdesktop)
      (nixGLWrap google-chrome)
      keepassxc
      obsidian
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
#      gnome.pomodoro
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

  };
}
