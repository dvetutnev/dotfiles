{
  description = "Ash nazg durbatulûk";

  inputs.nixpkgs = {
    url = "github:nixos/nixpkgs/nixos-unstable";
  };

  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
  };

  inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs.flake-utils.follows = "flake-utils";
  };

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nixgl = {
    url = "github:guibou/nixGL";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, ... } @inputs: {
    homeConfigurations."dvetutnev@vulpecula" = with inputs; import ./vulpecula.nix {
      inherit nixpkgs nixvim home-manager nixgl;
    };
  };
}

