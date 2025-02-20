{ config
, pkgs
, nixGLWrap
, ...
}:

{
  config = {

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
            PS1="\n\[\033[$PROMPT_COLOR\][\h:\w]\\$\[\033[0m\] "
          else
            PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\h: \w\a\]\h:\[\033[$DIR_COLOR\]\w\[\033[$PROMPT_COLOR\]]\[\033[0m\]\$ "
          fi
          if test "$TERM" = "xterm"; then
            PS1="\[\033]2;\h:\w\007\]$PS1"
          fi
        fi
      '';
    };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    home.packages = with pkgs; [
      config.nix.package
      (nixGLWrap neovide)
      (nixGLWrap qtcreator)
      (nixGLWrap mpv)
      (nixGLWrap tdesktop)
      (nixGLWrap google-chrome)
      (nixGLWrap obsidian)
      lazarus
      keepassxc
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
      plantuml
#      gnome.pomodoro
      hackgen-nf-font
      source-code-pro
    ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    fonts.fontconfig.enable = true;

    services.syncthing.enable = true;

    # Home Manager has an option to automatically set some environment variables
    # that will ease usage of software installed with nix on non-NixOS linux
    # (fixing local issues, settings XDG_DATA_DIRS, etc.):
    targets.genericLinux.enable = true;

    nix = {
      enable = true;
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
    };

  };
}
