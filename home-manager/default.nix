{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    "${inputs.meenzenDot}/home-manager/modules/starship.nix"
  ];
  programs.home-manager.enable = true;
  home.packages = [pkgs.atool pkgs.httpie];
  programs.bash.enable = true;
  home.stateVersion = "24.05";
  #  programs.starship.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.git = {
    enable = true;
    userName = "Slay326";
    userEmail = "sleither.reyes@gmx.de";
  };
}
