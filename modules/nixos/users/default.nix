{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkOption mkMerge mkIf types concatStringsSep;
  userModule = {lib, ...}: {
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
      home = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Optional override for the user's home directory (defaults to /home/<username>).";
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
  usersByName = config.slay.users or {};
  sel = config.slay.username or "";
  selectedUser =
    if sel != "" && builtins.hasAttr sel usersByName
    then usersByName.${sel}
    else null;
  resolvedActiveUser =
    if selectedUser == null
    then null
    else
      selectedUser
      // {
        fullName =
          if (selectedUser ? fullName) && (selectedUser.fullName or "") != ""
          then selectedUser.fullName
          else selectedUser.username;
        email =
          if selectedUser ? email
          then selectedUser.email
          else "";
        authorizedKeys =
          if selectedUser ? authorizedKeys
          then selectedUser.authorizedKeys
          else [];
        extraGroups =
          if selectedUser ? extraGroups
          then selectedUser.extraGroups
          else [];
        shell =
          if selectedUser ? shell
          then selectedUser.shell
          else pkgs.zsh;
        home =
          if (selectedUser ? home) && selectedUser.home != null
          then selectedUser.home
          else "/home/${selectedUser.username}";
        homeModule =
          if selectedUser ? homeModule
          then selectedUser.homeModule
          else null;
        initialPassword =
          if selectedUser ? initialPassword
          then selectedUser.initialPassword
          else null;
      };
in {
  options.slay = {
    users = mkOption {
      type = types.attrsOf (types.submodule userModule);
      default = {};
      description = "User database defined per host (or via shared module). Keys should match .username.";
    };

    username = mkOption {
      type = types.str;
      default = "";
      description = "Active login user for this host (must be a key of slay.users).";
    };

    activeUser = mkOption {
      type = types.nullOr (types.submodule userModule);
      readOnly = true;
      description = "Resolved user attrset derived from slay.username and slay.users.";
    };
  };

  config = mkMerge [
    {
      assertions = [
        {
          assertion = (config.slay.username or "") != "";
          message = "slay.username must be set.";
        }
        {
          assertion = resolvedActiveUser != null;
          message = let
            knownUsers = builtins.attrNames (config.slay.users or {});
            listMsg =
              if knownUsers == []
              then "<none>"
              else concatStringsSep ", " knownUsers;
          in "slay.username must match one of: ${listMsg}";
        }
      ];
    }

    {
      slay.activeUser = resolvedActiveUser;
    }
  ];
}
