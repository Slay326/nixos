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
        # Beispiel: plasma-manager global mitgeben
        sharedModules = [
          inputs.plasma-manager.homeModules.plasma-manager
          inputs.stylix.homeModules.stylix
          {
            # Stylix currently supports only qtct for the Qt target.
            stylix.targets.qt.platform = lib.mkDefault "qtct";
          }
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
