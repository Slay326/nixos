{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # include NixOS-vm modules
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      #      home-manager.users.nixos = import ./home-manager;

      # Optionally, use home-manager.extraSpecialArgs to pass
      # arguments to home.nix
    }
  ];

  vm = {
    enable = true;
    defaultUser = "vm";
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.docker.enable = true;
  networking.hostName = "vm";
  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.bash
    pkgs.qemu
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
