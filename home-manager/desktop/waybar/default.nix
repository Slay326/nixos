{
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
  };

  xdg.configFile = lib.mkForce {
    "waybar/config".source = ./config.jsonc;
    "waybar/style.css".source = ./style.css;
  };
}
