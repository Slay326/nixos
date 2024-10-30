{
  inputs = {
    # NixOS official package source, here using the nixos-23.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
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
  in {
    inherit (devShells) devShells;
    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      system = "x86_64-linux";
      modules = [
        ./nixos/systems/wsl/configuration.nix
      ];
    };
  };
}
