# modules/nixos/base/default.nix
{
  lib,
  pkgs,
  inputs,
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

  # extragrps ohne Primärgruppe
  sanitizedExtraGroups =
    if u == null
    then []
    else builtins.filter (g: g != u.username) u.extraGroups;
in {
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
          inputs.plasma-manager.homeManagerModules.plasma-manager
        ];
        extraSpecialArgs = {inherit inputs;};
      };
    }

    (mkIf (u != null) (mkMerge [
      # Primärgruppe + System-User
      {users.groups.${u.username} = {};}

      {
        users.users.${u.username} = {
          isNormalUser = true;
          isSystemUser = false;
          description = u.fullName or u.username;
          group = u.username;
          home = "/home/${u.username}";
          shell = mkDefault u.shell;
          extraGroups = sanitizedExtraGroups ++ ["wheel"];
          openssh.authorizedKeys.keys = u.authorizedKeys or [];
        };
      }

      # HM nur für diesen User – KEIN home.username/home.homeDirectory in HM setzen!
      {
        home-manager.users.${u.username}.imports = [
          (inputs.self + /home-manager/home.nix)
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
