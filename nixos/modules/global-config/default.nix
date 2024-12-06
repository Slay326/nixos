{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.slay.global-config;

  slay = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBRpzMsRHcgjCpvZfzmY7q3Er+7fXRwjwWXIHnVf91zkAAAABHNzaDo= s.reyes@human.de - Yubikey";
in {
  options.slay.global-config = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the global configuration.";
    };

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        # Admins
        slay
      ];
      description = "These keys will be added to the authorized_keys file of the root user on all systems.";
    };
  };

  config = lib.mkIf cfg.enable {
    security.sudo.wheelNeedsPassword = false;

    users = {
      # Always overwrite manually configured users
      mutableUsers = false;

      users = {
        slay = {
          isNormalUser = true;
          extraGroups = ["wheel"];
          openssh.authorizedKeys.keys = [slay];
        };
      };
    };
  };
}
