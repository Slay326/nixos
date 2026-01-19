{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  networking.hostName = "wsl";

  slay.docker.enable = true;
  slay.dotnet.enable = true;
  slay.wsl.enable = true;
  slay.wsl.defaultUser = config.slay.username;

  slay.users = {
    reyess = {
      username = "reyess";
      fullName = "Sleither Reyes";
      email = "s.reyes@human.de";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMa9vjZasAelcVAdtLa+vI0dYvx4hba2z6z+J+u39irB slay@dell"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKv9OqoVkdHyxXZ1n7ZUNOvb6ANAOiMUVZBOnhMPBcwI sleither.reyes@gmx.de"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICKXQxIZdFAYE0kDI/73H7vWZJWsVCgY+R7OPeNbfD9zAAAABHNzaDo= ssh:"
      ];
      extraGroups = ["docker"];
    };
  };
  slay.username = "reyess";

  environment.systemPackages = with pkgs; [
    git
    vim
    fastfetch
  ];

  system.stateVersion = "24.05";
}
