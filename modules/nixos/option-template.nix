{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.foo;
in {
  options.slay.foo = {
    enable = lib.mkEnableOption "Enable foo";
  };

  config = lib.mkIf cfg.enable {
    # some config
  };
}
