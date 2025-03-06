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
    initialPassword = "test";
    description = "Tester";
    extraGroups = ["wheel" "networkmanager" "input" "docker"];
  };

  slay.home-manager = {
    enable = false;
    homeModule = "${inputs.self}/home-manager/home.nix";
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
  ];
}
