{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}: let
  user = "og326";
  # Gemeinsame Dateien importieren
  #sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  #additionalFiles = import ./files.nix { inherit user config pkgs; };
in {
  # Definiere den Benutzer
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  # Konfiguration für Homebrew (dies ist ein nix-darwin Modul)
  homebrew = {
    enable = true;
    brews = {
      "git"
    };
    casks = pkgs.callPackage ./casks.nix {};
    masApps = {
      "hidden-bar" = 1452453066;
      "wireguard" = 1451685025;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${user} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};

        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];
        stateVersion = "23.11";
      };
      manual.manpages.enable = false;
    };
  };
}
