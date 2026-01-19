{
  config,
  lib,
  ...
}: let
  cfg = config.slay.virtualbox;
  activeUser = config.slay.activeUser;
in {
  options.slay.virtualbox = {
    enable = lib.mkEnableOption "VirtualBox";
    enableExtensionPack = lib.mkEnableOption "VirtualBox host extension pack";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        virtualisation.virtualbox.host.enable = true;
        virtualisation.virtualbox.host.enableExtensionPack = cfg.enableExtensionPack;
      }
      (lib.mkIf (activeUser != null) {
        users.users.${activeUser.username}.extraGroups = ["vboxusers"];
      })
    ]
  );
}
