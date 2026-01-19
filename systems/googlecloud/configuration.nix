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
    ./hardware-configuration.nix
    ../../modules/java/default.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.docker.enable = true;
  services.qemuGuest.enable = true;
  slay.java.enable = true;

  networking = {
    hostName = "gce-01";
  };

  environment.systemPackages = with pkgs; [
    neovim
    fastfetch
    wget
    google-guest-agent
  ];

  slay.users = {
    reyess = {
      username = "reyess";
      fullName = "Sleither Reyes";
      email = "s.reyes@human.de";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMa9vjZasAelcVAdtLa+vI0dYvx4hba2z6z+J+u39irB slay@dell"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKv9OqoVkdHyxXZ1n7ZUNOvb6ANAOiMUVZBOnhMPBcwI sleither.reyes@gmx.de"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICKXQxIZdFAYE0kDI/73H7vWZJWsVCgY+R7OPeNbfD9zAAAABHNzaDo= ssh:"
      ];
      extraGroups = ["networkmanager" "docker" "input"];
    };
  };
  slay.username = "reyess";

  system.stateVersion = "23.11";
}
