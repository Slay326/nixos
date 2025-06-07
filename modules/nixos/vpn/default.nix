{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.vpn;
in {
  options.slay.vpn = {
    enable = lib.mkEnableOption "Enable VPN Client";
  };

  config = lib.mkIf cfg.enable {
    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad-vpn;
  };
}
