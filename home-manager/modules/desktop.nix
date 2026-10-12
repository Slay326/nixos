{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    onedrive
    _1password-gui
  ];
  stylix.targets.ghostty.enable = false;
}
