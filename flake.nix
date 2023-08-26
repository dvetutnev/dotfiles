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

  outputs = { self, nixpkgs, ... } @inputs:
  {
    homeConfigurations."dvetutnev@vulpecula" = with inputs; import ./vulpecula.nix {
      inherit nixpkgs nixvim home-manager nixgl;
    };
    devShells."x86_64-linux".nvim = 
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    with pkgs; mkShell {
      nativeBuildInputs = [
        nixd
        nixpkgs-fmt
        (import ./nvim.nix { inherit pkgs; })
      ];
    };
  };
}

