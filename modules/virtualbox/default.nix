{
  config,
  lib,
  systemConfig,
  ...
}: let
  cfg = config.slay.virtualbox;
in {
  options.slay.virtualbox = {
    enable = lib.mkEnableOption "VirtualBox";
    enableExtensionPack = lib.mkEnableOption "VirtualBox host extension pack";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = cfg.enableExtensionPack;
    users.users."${systemConfig.user.username}".extraGroups = ["vboxusers"];
  };
}
