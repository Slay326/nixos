{
  config,
  lib,
  pkgs,
  inputs,
  systemConfig,
  ...
}: let
  cfg = config.slay.adb;
in {
  options.slay.adb = {
    enable = lib.mkEnableOption "Enable ADB";
  };

  config = lib.mkIf cfg.enable {
    programs.adb.enable = true;
    users.users."${systemConfig.user.username}".extraGroups = ["adbusers"];
  };
}
