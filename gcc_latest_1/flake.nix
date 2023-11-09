{
  description = "GCC latest with Conan";

  inputs.nixpkgs = {
    url = "github:nixos/nixpkgs/nixos-unstable";
  };

  inputs.dotfiles = {
    url = "github:dvetutnev/dotfiles";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, dotfiles }: {

    devShells.x86_64-linux.default = dotfiles.devShells.x86_64-linux.gcc_latest_1;

  };
