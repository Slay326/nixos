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
    taps = [
      "homebrew/services"
      "jorgelbg/tap"
      "junian/dotnet"
      "theseal/ssh-askpass"
    ];
    brews = [
      "act"
      "ant"
      "bbftp-client"
      "bitwarden-cli"
      "cabal-install"
      "clang-format"
      "cmake"
      "codex"
      "fd"
      "ffmpeg"
      "fftw"
      "fish"
      "fzf"
      "gh"
      "git"
      "gitlab-runner"
      "gitui"
      "glfw"
      "gnupg"
      "googletest"
      "ios-deploy"
      "jdtls"
      "keychain"
      "libsndfile"
      "lsusb"
      "mas"
      "maven"
      "minikube"
      "mkcert"
      "neovim"
      "nmap"
      "nss"
      "nvm"
      "opensc"
      "openssh"
      "opentofu"
      "pdftk-java"
      "perl"
      "php"
      "pinentry-mac"
      "pipx"
      "portaudio"
      "postgresql@17"
      "powerlevel10k"
      "proftpd"
      "pyenv-virtualenv"
      "python@3.12"
      "python@3.13"
      "redis"
      "starship"
      "terraform"
      "theseal/ssh-askpass/ssh-askpass"
      "tmux"
      "tokei"
      "volta"
      "wakeonlan"
      "wget"
      "wireguard-tools"
      "ykman"
      "yt-dlp"
      "yubico-piv-tool"
      "yubikey-agent"
      "zlib"
      "zsh"
    ];
    casks = [
      "basictex"
      "inkscape"
      "pdf-expert"
      "scroll-reverser"
      "supercollider"
    ];
    onActivation.autoUpdate = true;
    onActivation.upgrade = false;
  };

  #nix.settings.experimental-features = ["nix-command" "flakes"];
  #nix.linux-builder.enable = true;
  nix.enable = false;

  home-manager.users.${systemConfig.user.username} = {pkgs, ...}: {
    home.stateVersion = "23.11";
    home.packages = with pkgs; [];
  };

  home-manager.backupFileExtension = "backup";

  system.activationScripts.applications.text = let
    user = systemConfig.user.username;

    # System packages (falls GUI-Apps dort liegen)
    sysEnv = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = ["/Applications"];
    };

    # Home-Manager User Env (das ist bei dir entscheidend)
    userProfile = "/etc/profiles/per-user/${user}";
  in
    lib.mkForce ''
      set -euo pipefail

      echo "Setting up /Applications/Nix Apps..." >&2

      mkdir -p "/Applications/Nix Apps"

      # Alte Finder-Aliases entfernen (aber Ordner behalten!)
      find "/Applications/Nix Apps" -maxdepth 1 -type f -delete

      create_aliases_from() {
        local base="$1"
        local appdir="$base/Applications"

        if [ -d "$appdir" ]; then
          echo "Scanning $appdir" >&2
          find "$appdir" -maxdepth 1 -name "*.app" -print0 \
            | while IFS= read -r -d "" app; do
                app_name="$(basename "$app")"
                echo "Creating alias for $app_name" >&2
                ${pkgs.mkalias}/bin/mkalias \
                  "$app" \
                  "/Applications/Nix Apps/$app_name"
              done
        fi
      }

      # 1) Home-Manager / per-user Apps
      if [ -e "${userProfile}" ]; then
        create_aliases_from "${userProfile}"
      fi

      # 2) System-wide GUI Apps
      create_aliases_from "${sysEnv}"

      echo "Done."
    '';

  networking.hostName = "onyx";
  security.pam.services.sudo_local.touchIdAuth = true;

  #system
  system = {
    stateVersion = 4;
    primaryUser = "og326";
    defaults = {
      # minimal dock
      dock = {
        autohide = true;
        orientation = "bottom";
        show-process-indicators = true;
        show-recents = false;
        static-only = true;
      };
      # a finder that tells me what I want to know and lets me work
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        FXEnableExtensionChangeWarning = false;
      };
      #Tab between form controls and F-row that behaves as F1-F12
      NSGlobalDomain = {
        AppleKeyboardUIMode = 3;
        "com.apple.keyboard.fnState" = true;
      };
    };
  };
}
