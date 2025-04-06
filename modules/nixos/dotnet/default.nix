{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.dotnet;

  dotnet-combined = pkgs.dotnetCorePackages.combinePackages cfg.sdks;
in {
  options.slay.dotnet = {
    enable = lib.mkEnableOption "Enable dotnet";
    sdks = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs.dotnetCorePackages; [
        sdk_9_0
        sdk_8_0
      ];
      description = "List of SDKs to install";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dotnet-combined
    ];

    environment.sessionVariables = {
      DOTNET_ROOT = "${dotnet-combined}";
      MSBUILDTERMINALLOGGER = "auto";
    };
  };
}
