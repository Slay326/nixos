{pkgs, ...}: {
  home.packages = with pkgs; [
    onedrive
  ];
    stylix.targets.ghostty.enable = false;
}
