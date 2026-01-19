{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.slay.hardware.esp32;
  activeUser = config.slay.activeUser;
in {
  options.slay.hardware.esp32 = {
    enable = lib.mkEnableOption "Enable ESP32 support";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.udev.extraRules = ''
          # Espressif USB Serial/JTAG Controller
          SUBSYSTEM=="tty", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="0660", TAG+="uaccess"
        '';
      }
      (lib.mkIf (activeUser != null) {
        users.users.${activeUser.username}.extraGroups = ["dialout"];
      })
    ]
  );
}
