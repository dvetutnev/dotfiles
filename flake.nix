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
    nixOverlay = final: prev:
    {
      nix = prev.nix.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          ./enable_at_in_path.patch
        ];
      });
    };
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        nixOverlay
      ];
    };

    mkNixGLWrapper = pkgs.callPackage ./mkNixGLWrapper.nix {};
    nixGLWrap = mkNixGLWrapper nixgl.packages.${system}.nixGLIntel;

    cppDevShell = compiler: conan:
      pkgs.mkShell.override { stdenv = compiler; } {
        nativeBuildInputs = with pkgs; [
          compiler
          cmake
          ninja
          gdb
          clang-tools_16
          cmake-format
        ] ++ [
          conan
        ];
      };
  in
  {
    lib.nixGLWrap = nixGLWrap;
    lib.homeManagerConfiguration = home-manager.lib.homeManagerConfiguration;

    packages.${system} = {
      nvim = pkgs.callPackage ./nvim.nix {};
      tg = (nixGLWrap pkgs.tdesktop);
      nix = pkgs.nix;
    };

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

    devShells."x86_64-linux".gcc_latest =
    let
      compiler = with pkgs; (overrideCC stdenv gcc_latest);
      conan  = (pkgs.callPackage ./conan_2.nix {});
   in
      cppDevShell compiler conan;

    devShells."x86_64-linux".gcc_latest_1 =
    let
      compiler = with pkgs; (overrideCC stdenv gcc_latest);
      conan  = (pkgs.callPackage ./conan_1.nix {});
    in
      cppDevShell compiler conan;

    devShells."x86_64-linux".clang16 = cppDevShell pkgs.llvmPackages_16.libcxxStdenv;

    templates.gcc_latest_1.path = ./gcc_latest_1;

  };
}

