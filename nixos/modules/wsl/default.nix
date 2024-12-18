{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.slay.wsl;
in {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  options.slay.wsl = {
    enable = lib.mkEnableOption "Enable WSL";
    defaultUser = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "Default user for WSL instance";
    };
  };

  config = lib.mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = cfg.defaultUser;
    };
  };
}
