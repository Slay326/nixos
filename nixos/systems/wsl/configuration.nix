# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.nixos = import "${inputs.self}/home-manager";
      home-manager.extraSpecialArgs = {
        inherit inputs;
      };

      # Optionally, use home-manager.extraSpecialArgs to pass
      # arguments to home.nix
    }
  ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.docker.enable = true;

  networking = {
    hostName = "wsl";
  };
  environment.systemPackages = with pkgs; [
    neovim
    fastfetch
    wget
    nmap
    git
    bash
    husky
    curl
    (dotnetCorePackages.combinePackages [
      dotnetCorePackages.sdk_8_0
      dotnetCorePackages.sdk_9_0
    ])
    dotnetPackages.Nuget
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  programs.nix-ld.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
