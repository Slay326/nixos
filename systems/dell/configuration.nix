{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.dell-latitude-7430
    ./hardware-configuration.nix
  ];

  system.stateVersion = "23.11";
  networking.hostName = "nb-6462";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  boot.initrd.luks.devices."luks-d72b6916-393c-4db9-8194-6d48d1cf5189".device = "/dev/disk/by-uuid/d72b6916-393c-4db9-8194-6d48d1cf5189";

  slay.desktop.enable = true;
  slay.latest-kernel.enable = false;
  slay.virtualbox.enable = true;
  slay.hardware.bluetooth.enable = true;
  slay.hardware.uhk.enable = true;
  slay.hardware.esp32.enable = true;
/*   slay.home-manager.extraConfig = {
    additionalPinnedApps = [
      "applications:google-chrome.desktop"
      "applications:rider.desktop"
    ];
    additionalShownSystemTrayItems = [
      "org.kde.plasma.battery"
    ];
  };
 */
  services.teamviewer.enable = true;
}