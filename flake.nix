{
  description = "Ash nazg durbatulûk";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nixgl.url = "github:guibou/nixGL";
  inputs.nixgl.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager, nixgl }: {
    homeConfigurations."dvetutnev@vulpecula" = import ./vulpecula.nix {
      inherit nixpkgs home-manager nixgl;
    };
  };
}
