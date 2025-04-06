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
    # Verwende hier ein eigenes casks.nix-Modul, das die gewünschten Casks definiert
    casks = pkgs.callPackage ./casks.nix {};
    # Beispiel: App-IDs aus dem Mac App Store (via mas CLI)
    masApps = {
      "hidden-bar" = 1452453066;
      "wireguard" = 1451685025;
    };
  };

  # Home Manager Konfiguration für den Benutzer
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
        # Deaktiviert den nixpkgs Release Check (optional)
        enableNixpkgsReleaseCheck = false;
        # Installiere zusätzliche Pakete via Home Manager
        packages = pkgs.callPackage ./packages.nix {};
        # Mergen von gemeinsam geteilten Dateien (z. B. dotfiles)
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];
        stateVersion = "23.11";
      };

      # Falls du gemeinsame Programme oder weitere Home Manager Einstellungen aus einem Shared-Modul importieren möchtest:
      #programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Deaktiviert manuelle Manpages (falls Probleme auftreten)
      manual.manpages.enable = false;
    };
  };
}
