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
    slay.bootloader.enable = true;
    slay.docker.enable = true;
    slay.dotnet.enable = false;
    slay.fonts.enable = true;
    slay.java.enable = true;
    slay.plasma.enable = true;
    slay.stylix.enable = true;
    slay.yubikey.enable = true;
  };
}
