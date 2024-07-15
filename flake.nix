{
  description = "Srid's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    #flake utitlity funcitons
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";

    # inputs for mac systems
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # manager user environtment
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-flake.url = "github:srid/nixos-flake";
    nixpkgs-match.url = "github:srid/nixpkgs-match";
    nuenv.url = "github:DeterminateSystems/nuenv";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit (inputs) self; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      imports = [
        inputs.nixos-flake.flakeModule
        ./users
        ./home
        ./nixos
        ./nix-darwin
      ];

      flake = {

        # Configurations for my (only) macOS machine (using nix-darwin)
        darwinConfigurations = {
          nmcc-laptop = self.nixos-flake.lib.mkARMMacosSystem {
            imports = [
              self.darwinModules.default # Defined in nix-darwin/default.nix
              # ./nixos/hercules.nix
              ./systems/darwin.nix
            ];
          };
        };
      };

      perSystem = { self', pkgs, config, inputs', ... }: {
        packages.default = self'.packages.activate;
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt
            pkgs.sops
            pkgs.ssh-to-age
            (self.nixosConfigurations."pce".config.jenkins-nix-ci.nix-prefetch-jenkins-plugins pkgs)
          ];
        };
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
