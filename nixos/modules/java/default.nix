{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.java;

  java-combined = pkgs.javaPackages.combinePackages cfg.sdks;
in {
  options.human.dotnet = {
    enable = lib.mkEnableOption "Enable dotnet";
    sdks = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        jre8
      ];
      description = "List of SDKs to install";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dotnet-combined
    ];

    environment.sessionVariables = {
      JAVA_ROOT = "${java-combined}";
      MSBUILDTERMINALLOGGER = "auto";
    };
  };
}
