{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./gtk.nix
    ./qt.nix
  ];

  home.packages = with pkgs; [
    halloy
    signal-desktop
    tdesktop

    gnome-calculator
    gnome-control-center

    overskride
    resources
    wineWowPackages.wayland

    inputs.nix-matlab.packages.${pkgs.system}.matlab
  ];

  xdg.configFile."matlab/nix.sh".text = "INSTALL_DIR=$XDG_DATA_HOME/matlab/installation";
}
