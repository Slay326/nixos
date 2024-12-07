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

  system.stateVersion = "23.11";
}
