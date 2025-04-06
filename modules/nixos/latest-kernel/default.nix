{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.latest-kernel;
in {
  options.slay.latest-kernel = {
    enable = lib.mkEnableOption "Enable Latest Kernel";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
