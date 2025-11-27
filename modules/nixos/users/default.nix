{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types;
  userModule = {
    lib,
    pkgs,
    ...
  }: {
    options = {
      username = mkOption {
        type = types.str;
        description = "Login name";
      };
      fullName = mkOption {
        type = types.str;
        default = "";
      };
      email = mkOption {
        type = types.str;
        default = "";
      };
      authorizedKeys = mkOption {
        type = types.listOf types.str;
        default = [];
      };
      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [];
      };
      shell = mkOption {
        type = types.package;
        default = pkgs.zsh;
      };
      homeModule = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Optional override for the Home Manager module imported for this user.";
      };
      initialPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Optional initial password for this user (use only for throwaway/test systems).";
      };
    };
  };
in {
  options.slay = {
    users = mkOption {
      type = types.attrsOf (types.submodule userModule);
      default = {};
      description = "User database defined per host (or via shared module). Keys should match .username.";
    };

    # Welcher User ist auf DIESEM Host aktiv?
    username = mkOption {
      type = types.str;
      default = "";
      description = "Active login user for this host (must be a key of slay.users).";
    };
  };
}
