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

  inputs.nix-on-droid = {
    url = "github:nix-community/nix-on-droid/release-24.05";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  inputs.nixgl = {
    url = "github:guibou/nixGL";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, nixgl, home-manager, nix-on-droid, ... } @inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    mkNixGLWrapper = pkgs.callPackage ./mkNixGLWrapper.nix {};
    nixGLWrap = mkNixGLWrapper nixgl.packages.${system}.nixGLIntel;

    cppDevShell = compiler: conan:
      pkgs.mkShell.override { stdenv = compiler; } {
        hardeningDisable = [ "all" ];
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

    forAllSystems = f:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
	"aarch64-linux"
      ] (system: f nixpkgs.legacyPackages.${system});
  in
  {
    lib.nixGLWrap = nixGLWrap;
    lib.homeManagerConfiguration = home-manager.lib.homeManagerConfiguration;

    #packages.${system} = {
    #  nvim = pkgs.callPackage ./nvim.nix {};
    #  tg = (nixGLWrap pkgs.tdesktop);
    #  nix = pkgs.nix;
    #};

    packages = forAllSystems (pkgs: {
      nvim = pkgs.callPackage ./nvim.nix{};
    });

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

#    homeConfigurations.T60 = self.lib.homeManagerConfiguration {
#      pkgs = import nixpkgs {
#        system = "aarch64-linux";
#        config.allowUnfree = true;
#      };
#      extraSpecialArgs = {
#        nvim = self.packages.aarch64-linux.nvim;
#      };
#      modules = [
#        ./T60.nix
#      ];
#    };

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration rec {
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };
      extraSpecialArgs = {
        nvim = pkgs.callPackage ./nvim.nix {};
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
          home-manager.extraSpecialArgs.nvim = self.packages.${system}.nvim;
          home-manager.users.dvetutnev = import ./lynx_home.nix;
        }
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

