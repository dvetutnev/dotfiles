{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    options = {
      number = true;
      relativenumber = true;

      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smarttab = true;
      smartindent = true;

      list = true;
      listchars = "tab:>-";
    };
    plugins = {
      nix.enable = true;
      lsp = {
        enable = true;
        servers.nixd.enable = true;
      };

    };
    extraPlugins = with pkgs.vimPlugins; [
      vim-solarized8
      nvim-web-devicons
    ];
    colorscheme = "solarized8_flat";
    options.termguicolors = true;
  };
}

