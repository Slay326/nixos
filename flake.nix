{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    meenzenDot.url = "github:meenzen/nixos/main";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    agenix,
    ...
  } @ inputs: let
    devShells =
      flake-utils.lib.eachDefaultSystem
      (
        system: let
          pkgs = import nixpkgs {
            inherit system;
          };
        in {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              git
              nixVersions.stable
              nil
              alejandra
              agenix.packages."${system}".default
            ];
            shellHook = ''
              echo ""
              echo "$(git --version)"
              echo "$(nil --version)"
              echo "$(alejandra --version)"
              echo ""
            '';
          };
        }
      );
    system = "x86_64-linux";
  in {
    inherit (devShells) devShells;

    nixosModules = rec {
      slay = import ./nixos/modules;
      default = slay;
    };

    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
        modules = [
          ./nixos/systems/wsl/configuration.nix
        ];
      };
    };

    nixosConfigurations = {
      googlecloud = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
        modules = [
          ./nixos/systems/googlecloud/configuration.nix
        ];
      };
    };
  };
}
