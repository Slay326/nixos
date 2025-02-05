{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.bitwarden;
in {
  options.slay.bitwarden = {
    enable = lib.mkEnableOption "Enable Bitwarden";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
        bitwarden-desktop
    ];
  };
}
