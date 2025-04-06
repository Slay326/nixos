{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.slay.cloudflare-warp;
in {
  options.slay.cloudflare-warp = {
    enable = lib.mkEnableOption "Enable Cloudflare Warp Client";
  };

  config = lib.mkIf cfg.enable {
    services.cloudflare-warp.enable = true;
  };
}
