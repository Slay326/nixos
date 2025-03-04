{
  inputs,
  lib,
  config,
  pkgs,
  systemConfig,
  ...
}: {
  system.stateVersion = "24.11";
  networking.hostName = "vm-desktop";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  services.qemuGuest.enable = true;

  # Don't forget to define the user
  users.groups.${systemConfig.user.username} = {};
  users.users.${systemConfig.user.username} = {
    isNormalUser = true;
    initialPassword = "password";
    description = "Tester";
    extraGroups = ["wheel" "networkmanager" "input" "docker"];
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    
  };
}
