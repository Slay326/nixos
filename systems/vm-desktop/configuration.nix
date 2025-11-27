{
  inputs,
  lib,
  config,
  pkgs,
  systemConfig,
  modulesPath,
  ...
}: {
  imports = ["${modulesPath}/virtualisation/qemu-vm.nix"];
  system.stateVersion = "24.11";
  networking.hostName = "vm-desktop";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  services.qemuGuest.enable = true;

  slay.users.${systemConfig.user.username} = {
    username = systemConfig.user.username;
    fullName = systemConfig.user.fullName;
    email = systemConfig.user.email;
    authorizedKeys = systemConfig.user.authorizedKeys;
    extraGroups = ["networkmanager" "input" "docker"];
    initialPassword = "test";
  };
  slay.username = systemConfig.user.username;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
  ];

  virtualisation.sharedDirectories = {
    dev = {
      source = "/home/reyess/dev";
      target = "/mnt/dev";
      #fsType = "9p";
      #options = ["trans=virtio" "cache=loose"];
      securityModel = "mapped-file";
    };
  };
}
