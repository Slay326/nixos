# modules/nixos/base/default.nix
{
  lib,
  pkgs,
  inputs,
  outputs,
  systemConfig,
  config,
  ...
}: let
  inherit (lib) mkOption mkIf mkMerge types mkDefault;
  activeUser = config.slay.activeUser;
  hasActiveUser = activeUser != null;
  hmBackupCommand = pkgs.writeShellScript "home-manager-backup" ''
    set -eu

    target="$1"
    ext="''${HOME_MANAGER_BACKUP_EXT:-backup}"
    stamp="$(date +%Y%m%d%H%M%S)"
    backup="$target.$ext.$stamp"
    i=0

    while [ -e "$backup" ]; do
      i=$((i + 1))
      backup="$target.$ext.$stamp.$i"
    done

    mv -- "$target" "$backup"
  '';

  cfgHome = config.slay.home;
  defaultHomeModule = inputs.self + /home-manager/home.nix;
  defaultExtraConfig = {
    additionalPinnedApps = [];
    additionalShownSystemTrayItems = [];
  };
  resolvedHomeModule =
    if hasActiveUser && activeUser.homeModule != null
    then activeUser.homeModule
    else cfgHome.homeModule;

  # extragrps ohne Primärgruppe
  sanitizedExtraGroups =
    if !hasActiveUser
    then []
    else builtins.filter (g: g != activeUser.username) activeUser.extraGroups;
in {
  options.slay.home = {
    homeModule = mkOption {
      type = types.path;
      default = defaultHomeModule;
      description = "Path to the primary Home Manager module for the selected user.";
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = defaultExtraConfig;
      apply = x: lib.recursiveUpdate defaultExtraConfig x;
      description = "Additional configuration passed to the Home Manager modules (e.g. Plasma tweaks).";
    };
  };

  imports = [inputs.home-manager.nixosModules.home-manager];

  config = mkMerge [
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        backupCommand = "${hmBackupCommand}";
        # Beispiel: plasma-manager global mitgeben
        sharedModules = [
          inputs.plasma-manager.homeModules.plasma-manager
        ];
        extraSpecialArgs = {
          inherit inputs outputs systemConfig;
          extraConfig = cfgHome.extraConfig;
        };
      };
    }

    (mkIf hasActiveUser (mkMerge [
      # Primärgruppe + System-User
      {users.groups.${activeUser.username} = {};}

      {
        users.users.${activeUser.username} =
          {
            isNormalUser = true;
            isSystemUser = false;
            description = activeUser.fullName or activeUser.username;
            group = activeUser.username;
            home = activeUser.home;
            shell = mkDefault activeUser.shell;
            extraGroups = sanitizedExtraGroups ++ ["wheel"];
            openssh.authorizedKeys.keys = activeUser.authorizedKeys or [];
          }
          // (
            if activeUser.initialPassword != null
            then {initialPassword = activeUser.initialPassword;}
            else {}
          );
      }

      # HM nur für diesen User – KEIN home.username/home.homeDirectory in HM setzen!
      {
        home-manager.users.${activeUser.username}.imports = [
          resolvedHomeModule
        ];
      }

      # Optional: SSH-only (keine Passwörter in der Flake)
      {
        users.mutableUsers = true;
        services.openssh.settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      }
    ]))
  ];
}
