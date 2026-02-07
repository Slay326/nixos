{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  slay.username = "slay";
  slay.users = {
    slay = {
      username = "slay";
      fullName = "Sleither Reyes";
      email = "sleither.reyes@gmx.de";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMa9vjZasAelcVAdtLa+vI0dYvx4hba2z6z+J+u39irB slay@dell"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKv9OqoVkdHyxXZ1n7ZUNOvb6ANAOiMUVZBOnhMPBcwI sleither.reyes@gmx.de" #Maybe remove this
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICKXQxIZdFAYE0kDI/73H7vWZJWsVCgY+R7OPeNbfD9zAAAABHNzaDo= ssh:"
      ];
      extraGroups = ["networkmanager" "docker" "input"];
    };
  };

  slay.desktop.enable = true;
  slay.bitwarden.enable = true;
  slay.hardware.bluetooth.enable = true;
  slay.hardware.uhk.enable = true;
  slay.hardware.esp32.enable = true;
  slay.hardware.nvidia.enable = true;
  slay.git.signing.enable = true;
  #slay.hyprland.enable = true;
  slay.cloudflare-warp.enable = false;
  security.sudo.wheelNeedsPassword = false;
  home-manager.backupFileExtension = "backup";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "quartz-nix";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    kdePackages.ksshaskpass
    obsidian
    termius
    codex
    spotify
    desktop-file-utils
    colmena
    dbeaver-bin
    terraform
    obs-studio
    opentofu
    tofu-ls
    qemu
    wget
    unzip
    coreutils
    wireguard-ui
    yarn
    ffmpeg
    fprintd
    libfprint
    #nodejs_22
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "25.05";
}
