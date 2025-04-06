{
  config,
  pkgs,
  lib,
  inputs,
  systemConfig,
  ...
}: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  users.users.${systemConfig.user.username} = {
    name = systemConfig.user.username;
    home = "/Users/${systemConfig.user.username}";
  };

  ids.gids.nixbld = 350;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    htop
    mkalias
    fastfetch
    colmena
    alejandra
  ];

  environment.variables = {
    LANG = "en_US.UTF-8";
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  homebrew = {
    enable = true;
    brews = [
      "mas"
      "minikube"
      "openssh"
    ];
    casks = [
    ];
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  home-manager.users.${systemConfig.user.username} = {pkgs, ...}: {
    home.stateVersion = "23.11";
    home.packages = with pkgs; [];
  };

  home-manager.backupFileExtension = "backup";

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  networking.hostName = "onyx";
  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 4;
}
