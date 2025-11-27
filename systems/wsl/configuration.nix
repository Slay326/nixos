{
  inputs,
  lib,
  config,
  pkgs,
  systemConfig,
  ...
}: {
  networking.hostName = "wsl";

  slay.docker.enable = true;
  slay.dotnet.enable = true;
  slay.wsl.enable = true;
  slay.wsl.defaultUser = systemConfig.user.username;

  slay.users.${systemConfig.user.username} = {
    username = systemConfig.user.username;
    fullName = systemConfig.user.fullName;
    email = systemConfig.user.email;
    authorizedKeys = systemConfig.user.authorizedKeys;
    extraGroups = ["docker"];
  };
  slay.username = systemConfig.user.username;

  environment.systemPackages = with pkgs; [
    git
    vim
    fastfetch
  ];

  system.stateVersion = "24.05";
}
