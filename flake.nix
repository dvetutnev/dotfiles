{
  description = "Ash nazg durbatulûk";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nixgl.url = "github:guibou/nixGL";
  inputs.nixgl.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager, nixgl }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      nixGL = import ./nixGL.nix { inherit pkgs; };
      nixGLWrap = nixGL nixgl.packages.${system}.nixGLIntel;
    in {
      homeConfigurations.vulpecula = (home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
      #    ./home.nix
      #    {
      #      inherit nixGLWrap;
      #      home.packages = [ nixgl.packages.${system}.nixGLIntel ];
      #    }
      {
      home = {
        username = "dvetutnev";
        homeDirectory = "/home/dvetutnev";
        stateVersion = "22.05";
        packages = [ nixgl.packages.${system}.nixGLIntel (nixGLWrap pkgs.qtcreator) ];
      };
    }
        ];
      });
    };
}
