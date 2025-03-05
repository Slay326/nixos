{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.var;
in {
  options.var = {
    wallpaper = mkOption {
      type = types.path;
      default = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath}";
      description = "Default wallpaper path";
    };
  };

  config = {};
}
