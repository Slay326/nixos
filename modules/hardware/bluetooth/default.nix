{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.slay.hardware.bluetooth;
in {
  options.slay.hardware.bluetooth = {
    enable = lib.mkEnableOption "Enable bluetooth support";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
  };
}
