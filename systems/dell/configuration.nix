{
  inputs,
  lib,
  config,
  systemConfig,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.dell-latitude-7430
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.11";
  networking.hostName = "nb-6462";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  boot.initrd.luks.devices."luks-d72b6916-393c-4db9-8194-6d48d1cf5189".device = "/dev/disk/by-uuid/d72b6916-393c-4db9-8194-6d48d1cf5189";
  users.users.${systemConfig.user.username} = {
    isNormalUser = true;
    description = systemConfig.user.fullName;
    password = systemConfig.user.initialPassword;
    extraGroups = systemConfig.user.extraGroups;
    openssh.authorizedKeys.keys = systemConfig.user.authorizedKeys;
  };
  security.sudo.wheelNeedsPassword = false;
  slay.desktop.enable = true;
  services.endlessh.openFirewall = true;
  slay.latest-kernel.enable = false;
  slay.virtualbox.enable = true;
  slay.hardware.bluetooth.enable = true;
  slay.hardware.uhk.enable = true;
  slay.hardware.esp32.enable = true;
  
  services.teamviewer.enable = true;
}