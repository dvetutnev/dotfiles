{
  description = "Ash nazg durbatulûk";

  inputs.nixpkgs = {
    url = "github:nixos/nixpkgs/nixos-unstable";
  };

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nix-on-droid = {
    url = "github:nix-community/nix-on-droid/release-24.05";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  outputs = { self, nixpkgs, home-manager, nix-on-droid, ... } :
  let
    forAllSystems = f:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ]
      (system: f nixpkgs.legacyPackages.${system});
  in
  {
    packages = forAllSystems (pkgs: {
      nvim = pkgs.callPackage ./nvim.nix {};
    });

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration rec {
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };
      extraSpecialArgs = {
        nvim = self.packages."aarch64-linux".nvim;
      };
      modules = [ ./T60.nix ];
    };

    nixosConfigurations.lynx = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        lynx/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            nvim = self.packages.${system}.nvim;
          };
          home-manager.users.dvetutnev = import ./lynx_home.nix;
        }
      ];
    };
  };
}

