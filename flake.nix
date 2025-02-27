{
  description = "Personal NixOS configuration.";

  inputs = {
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-meenzen.url = "github:meenzen/nixpkgs/nixos-unstable";

    # Helper Libraries
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    colmena = {
      url = "github:zhaofengli/colmena";
      # current nixpkgs is not compatible
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Customization
    stylix.url = "github:danth/stylix/release-24.11";
    nixvim.url = "github:nix-community/nixvim";
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Other Programs
    authentik-nix.url = "github:nix-community/authentik-nix";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    hyprland,
    colmena,
    agenix,
    catppuccin,
    ...
  } @ inputs: let
    inherit (self) outputs;

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
              colmena.packages."${system}".colmena
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

    defaultConfig = {
      user = {
        username = "reyess";
        fullName = "Sleither Reyes";
        email = "s.reyes@human.de";
        isSystemUser = true;
        initialPassword = "password";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMa9vjZasAelcVAdtLa+vI0dYvx4hba2z6z+J+u39irB slay@dell"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIB4aA4A1deXxm7i59Hb5S1gEygIluOLZluHnfGUWBVHUAAAABHNzaDo= Slay326"
        ];
        extraGroups = ["networkmanager" "wheel" "input" "reyess" "docker"];
      };
    };

    mkSystem = systemModule: let
      systemConfig = defaultConfig;
    in
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            hyprland
            outputs
            systemConfig
            ;
        };
        modules = [
          ./modules
          systemModule
        ];
      };

    mkServer = targetHost: systemModule: {
      deployment.targetHost = targetHost;
      imports = [systemModule];
    };
  in {
    inherit (devShells) devShells;

    nixosConfigurations = {
      nb-6462 = mkSystem ./systems/test/configuration.nix;
      install-iso = mkSystem ./systems/install-iso/configuration.nix;
      test = mkSystem ./systems/test/configuration.nix;
    };
  };
}
