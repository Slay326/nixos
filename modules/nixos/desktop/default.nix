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
    #slay.javascript.enable = true;
    slay.plasma.enable = true;
    slay.stylix.enable = true;
    # Plasma provides the native KDE Qt platform theme; qtct can select Kvantum
    # and break Plasma QML when that plugin is not present.
    slay.stylix.qtPlatform = "kde";
    slay.yubikey.enable = true;
  };
}
