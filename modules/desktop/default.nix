{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.desktop;
in {
  options.slay.desktop = {
    enable = lib.mkEnableOption "Enable desktop related options";
  };

  config = lib.mkIf cfg.enable {
    slay.adb.enable = true;
    slay.bootloader.enable = true;
    slay.docker.enable = true;
    #slay.fonts.enable = true;
    slay.home-manager.enable = true;
    slay.plasma.enable = true;
    slay.stylix.enable = true;
    slay.yubikey.enable = true;
  };
}
