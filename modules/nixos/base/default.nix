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
  inherit (lib) mkOption mkIf mkMerge types concatStringsSep mkDefault;
  usersByName = config.slay.users or {};
  sel = config.slay.username or "";
  hasSel = builtins.hasAttr sel usersByName;
  u =
    if hasSel
    then usersByName.${sel}
    else null;

  cfgHome = config.slay.home;
  defaultHomeModule = inputs.self + /home-manager/home.nix;
  defaultExtraConfig = {
    additionalPinnedApps = [];
    additionalShownSystemTrayItems = [];
  };
  resolvedHomeModule =
    if u != null && u.homeModule != null
    then u.homeModule
    else cfgHome.homeModule;

  # extragrps ohne Primärgruppe
  sanitizedExtraGroups =
    if u == null
    then []
    else builtins.filter (g: g != u.username) u.extraGroups;
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
      assertions = [
        {
          assertion = sel != "";
          message = "slay.username must be set.";
        }
        {
          assertion = hasSel;
          message = "slay.username must be one of: ${concatStringsSep ", " (builtins.attrNames usersByName)}";
        }
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
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

    (mkIf (u != null) (mkMerge [
      # Primärgruppe + System-User
      {users.groups.${u.username} = {};}

      {
        users.users.${u.username} =
          {
            isNormalUser = true;
            isSystemUser = false;
            description = u.fullName or u.username;
            group = u.username;
            home = "/home/${u.username}";
            shell = mkDefault u.shell;
            extraGroups = sanitizedExtraGroups ++ ["wheel"];
            openssh.authorizedKeys.keys = u.authorizedKeys or [];
          }
          // (
            if u.initialPassword != null
            then {initialPassword = u.initialPassword;}
            else {}
          );
      }

      # HM nur für diesen User – KEIN home.username/home.homeDirectory in HM setzen!
      {
        home-manager.users.${u.username}.imports = [
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
