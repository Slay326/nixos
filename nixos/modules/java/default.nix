{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.java;
in {
  options.slay.java = {
    enable = lib.mkEnableOption "Enable java";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; 
    [
      jre8
    ];
  };
}
