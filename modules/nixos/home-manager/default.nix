{
  config,
  lib,
  inputs,
  outputs,
  pkgs,
  systemConfig,
  ...
} @ args: let
  # Hole den Systemwert aus den übergebenen extraSpecialArgs:
  currentSystem = args.system;
  cfg = config.slay.home-manager;
  isDarwin = builtins.elem currentSystem ["aarch64-darwin" "x86_64-darwin"];
  homeManagerModule =
    if isDarwin
    then inputs.home-manager.darwinModules.home-manager
    else inputs.home-manager.nixosModules.home-manager;
in {
  options.slay.home-manager = {
    enable = lib.mkEnableOption "Enable Home Manager";

    homeModule = lib.mkOption {
      type = lib.types.path;
      default = "${inputs.self}/home-manager/home.nix";
      description = ''
        Path to the home-manager module of the main user.
      '';
    };

    extraConfig = let
      defaultExtraConfig = {
        additionalPinnedApps = [];
        additionalShownSystemTrayItems = [];
      };
    in
      lib.mkOption {
        type = lib.types.attrs;
        default = defaultExtraConfig;
        apply = x: lib.recursiveUpdate defaultExtraConfig x;
        description = ''
          Extra configuration to pass to the home-manager of the main user.
        '';
      };
  };

  imports = [homeManagerModule];

  config = lib.mkIf cfg.enable {
    home-manager = {
      extraSpecialArgs = {
        inherit inputs outputs systemConfig;
        extraConfig = cfg.extraConfig;
        utils = lib;
      };
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      users."${systemConfig.user.username}" = import cfg.homeModule;
      sharedModules = [inputs.plasma-manager.homeManagerModules.plasma-manager];
    };
  };
}
