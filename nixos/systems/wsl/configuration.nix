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
   users.users.${config.slay.wsl.defaultUser}.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    git
    vim
    fastfetch
  ];

  system.stateVersion = "24.05";
}
