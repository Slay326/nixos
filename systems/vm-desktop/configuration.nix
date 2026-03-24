{
  inputs,
  lib,
  config,
  pkgs,
  modulesPath,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = ["${modulesPath}/virtualisation/qemu-vm.nix"];
  system.stateVersion = "24.11";
  networking.hostName = "vm-desktop";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  services.qemuGuest.enable = true;

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
      extraGroups = ["networkmanager" "input" "docker"];
      initialPassword = "test";
    };
  };
  slay.username = "reyess";

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.hyprland-contrib.packages.${system}.grimblast
    inputs.hyprpaper.packages.${system}.hyprpaper
  ];

  virtualisation.sharedDirectories = {
    dev = {
      source = "${config.slay.activeUser.home}/dev";
      target = "/mnt/dev";
      #fsType = "9p";
      #options = ["trans=virtio" "cache=loose"];
      securityModel = "mapped-file";
    };
  };
}
