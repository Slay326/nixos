{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.ghostty;
in {
  options.slay.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
        ghostty-desktop
    ];
  };
}
