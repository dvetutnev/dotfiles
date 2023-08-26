{ pkgs ? import <nixpkgs> {} }:
let
  neovim = pkgs.neovim.override {
    configure = {
      customRC = ''
        lua <<EOF
        ${luaRC}
        EOF
      '';

      packages.myPlugins.start = with pkgs.vimPlugins; [
        vim-solarized8
        vim-better-whitespace
      ];
    };
  };

  luaRC = ''
    vim.cmd.colorscheme('solarized8_flat')

    local options = {
      termguicolors = true,
      -- Tab key & indent
      tabstop = 2,
      shiftwidth = 2,
      expandtab = true,
      smarttab = true,
      autoindent = true,
      -- Line numbers
      number = true,
      relativenumber = true,
      -- Behavior
      undofile = true,
      scrolloff = 8
    }

    for k, v in pairs(options) do
      vim.opt[k] = v
    end

    local initvars = {
      better_whitespace_enabled = 1,
      strip_whitespace_on_save = 1
    }

    for k, v in pairs(initvars) do
      vim.g[k] = v
    end
  '';

in
  neovim
