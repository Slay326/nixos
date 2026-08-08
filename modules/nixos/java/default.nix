{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.java;
in {
  options.slay.java = {
    enable = lib.mkEnableOption "Enable java";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.jdk25;
      description = "Default JDK used for java, javac, and JAVA_HOME.";
    };
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        jre8
      ];
      description = "Additional Java runtimes/JDKs installed without taking precedence over the default JDK.";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.java = {
      enable = true;
      package = cfg.package;
    };

    environment.systemPackages = map lib.lowPrio cfg.extraPackages;
  };
}
