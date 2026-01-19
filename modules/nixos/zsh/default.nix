{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkMerge mkIf;
  activeUser = config.slay.activeUser;
in {
  config = mkMerge [
    {
      programs.zsh.enable = true;

      # make completions work
      environment.pathsToLink = ["/share/zsh"];
    }

    (mkIf (activeUser != null) {
      users.users.${activeUser.username}.shell = pkgs.zsh;
    })
  ];
}
