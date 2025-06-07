{pkgs, ...}: {
  home.packages = with pkgs; [
    cowsay
    ponysay
    fastfetch
    asciiquarium
    clolcat
    cmatrix
    fortune
    sl
    bb
  ];
}
