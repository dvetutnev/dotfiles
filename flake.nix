{
  description = "Ash nazg durbatulûk";

  inputs.nixpkgs = {
    url = "github:nixos/nixpkgs/nixos-unstable";
  };

  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
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

  outputs = { self, nixpkgs, nixgl, home-manager, ... } @inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    mkNixGLWrapper = pkgs.callPackage ./mkNixGLWrapper.nix {};
    nixGLWrap = mkNixGLWrapper nixgl.packages.${system}.nixGLIntel;
  in
  {
    lib.nixGLWrap = nixGLWrap;
    lib.homeManagerConfiguration = home-manager.lib.homeManagerConfiguration;

    packages.${system}.nvim = pkgs.callPackage ./nvim.nix {};

    nixosModules.home = import ./home.nix;

    homeConfigurations."dvetutnev@vulpecula" = self.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        nixGLWrap = self.lib.nixGLWrap;
        nvim = self.packages.${system}.nvim;
      };
      modules = [
        self.nixosModules.home
        ./vulpecula.nix
      ];
    };

    devShells."x86_64-linux".nvim = with pkgs; mkShell {
      nativeBuildInputs = [
        nixd
        nixpkgs-fmt
        nvim
      ];
    };

    devShells."x86_64-linux"."42" =
    let
      compiler = with pkgs; (overrideCC stdenv gcc13);
    in
    with pkgs; mkShell.override { stdenv = compiler; } {
      nativeBuildInputs = [
        compiler
        cmake
        ninja
        gdb
        clang-tools_16
        cmake-format
        self.packages.${system}.nvim
        git
        (nixGLWrap qtcreator)
      ];
    };
  };
}

