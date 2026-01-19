{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  activeUser = config.slay.activeUser;
in {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
  ];

  system.stateVersion = "23.11";
  networking.hostName = "install-iso";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Faster build, see https://nixos.wiki/wiki/Creating_a_NixOS_live_CD#Building_faster
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  # Enable the OpenSSH server so we can install the system remotely
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
  users.users.root.openssh.authorizedKeys.keys = activeUser.authorizedKeys;
  users.users.nixos.openssh.authorizedKeys.keys = activeUser.authorizedKeys;

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
      extraGroups = ["networkmanager" "docker" "input"];
    };
  };
  slay.username = "reyess";

  # force conflicting options
  services.pulseaudio.enable = lib.mkForce false;
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
}
