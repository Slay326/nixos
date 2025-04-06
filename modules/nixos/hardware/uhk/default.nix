{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.slay.hardware.uhk;
in {
  options.slay.hardware.uhk = {
    enable = lib.mkEnableOption "Ultimate Hacking Keyboard (UHK) support";
  };

  config = lib.mkIf cfg.enable {
    hardware.keyboard.uhk.enable = true;
    environment.systemPackages = with pkgs; [
      uhk-agent
    ];
  };
}
