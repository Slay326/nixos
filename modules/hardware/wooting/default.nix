{
  config,
  lib,
  ...
}: let
  cfg = config.slay.hardware.wooting;
in {
  options.slay.hardware.wooting = {
    enable = lib.mkEnableOption "Wooting / Wootility support";
  };

  config = lib.mkIf cfg.enable {
    hardware.wooting.enable = true;
  };
}
