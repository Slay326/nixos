{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    onedrive
  ];
  gtk.gtk4.theme = config.gtk.theme;
  stylix.targets.ghostty.enable = false;
}
