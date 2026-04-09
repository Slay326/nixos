{
  description = "Personal NixOS configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
    nixpkgs-meenzen.url = "github:meenzen/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    # Helper Libraries
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
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
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.home-manager.follows = "home-manager";
    };
    nixvim.url = "github:nix-community/nixvim";
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Other Programs
    authentik-nix.url = "github:nix-community/authentik-nix";

    # Hyprland und zugehörige Pakete
    hyprland.url = "github:hyprwm/Hyprland";

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    colmena,
    agenix,
    catppuccin,
    nix-darwin,
    nix-homebrew,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    supportedSystems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

    nixosConfig = {
      user = {
        username = "reyess";
        fullName = "Sleither Reyes";
        email = "s.reyes@human.de";
        isNormalUser = true;
        initialPassword = "password";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKv9OqoVkdHyxXZ1n7ZUNOvb6ANAOiMUVZBOnhMPBcwI sleither.reyes@gmx.de"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC50x5DkP6krKFqSkL0vP6zU1o1VsTju91SEuoudqgVi quartz"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdwPMCh37mVvmKFBFuPW8DqR4v8+HWq0bRe6LC/3UoC onyx"
        ];
        extraGroups = ["networkmanager" "wheel" "input" "reyess" "docker"];
      };
    };

    darwinConfig = {
      user = {
        username = "og326";
        fullName = "Sleither Reyes";
        email = "sleither.reyes@gmx.de";
        authorizedKeys = [
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICKXQxIZdFAYE0kDI/73H7vWZJWsVCgY+R7OPeNbfD9zAAAABHNzaDo= ssh:"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC50x5DkP6krKFqSkL0vP6zU1o1VsTju91SEuoudqgVi quartz"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdwPMCh37mVvmKFBFuPW8DqR4v8+HWq0bRe6LC/3UoC onyx"
        ];
      };
    };

    mkSystem = systemModule: let
      systemConfig = nixosConfig;
    in
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs self systemConfig;
        };

        modules = [
          ({...}: {
            nixpkgs.overlays = [
              (import "${inputs.nixpkgs-mozilla}/firefox-overlay.nix")
            ];
            nixpkgs.config.allowUnfree = true;
          })

          ./modules/nixos
          systemModule
        ];
      };

    mkServer = targetHost: systemModule: {
      deployment.targetHost = targetHost;
      imports = [systemModule];
    };

    mkDarwin = systemModule: let
      systemConfig = darwinConfig;
    in
      nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          system = "aarch64-darwin";
          inherit
            inputs
            outputs
            self
            systemConfig
            ;
        };
        modules = [
          systemModule
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs outputs self systemConfig;};
              users."og326" = import ./modules/darwin/home.nix;
            };
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "og326";
              autoMigrate = true;
            };
          }
        ];
      };
  in
    (flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {inherit system;};

      wl-ocr = pkgs.writeShellScriptBin "wl-ocr" ''
        #!/usr/bin/env bash
        echo "OCR functionality"
        exit 0
      '';
    in {
      packages = {
        wl-ocr = wl-ocr;
      };

      devShells = {
        default = pkgs.mkShell {
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
      };
    }))
    // {
      nixosConfigurations = {
        nb-6462 = mkSystem ./systems/test/configuration.nix;
        install-iso = mkSystem ./systems/install-iso/configuration.nix;
        test = mkSystem ./systems/test/configuration.nix;
        vm-desktop = mkSystem ./systems/vm-desktop/configuration.nix;
        quartz-nix = mkSystem ./systems/quartz/configuration.nix;
      };

      darwinConfigurations = {
        onyx = mkDarwin ./systems/onyx/darwin-configuration.nix;
      };
    };
}
