{
  inputs,
  config,
  pkgs,
  systemConfig,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.dell-latitude-7430
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-db6649a5-d532-4d97-b7db-21c52c7f4157".device = "/dev/disk/by-uuid/db6649a5-d532-4d97-b7db-21c52c7f4157";
  networking.hostName = "nb-6462"; 
  networking.networkmanager.enable = true;
  home-manager.backupFileExtension = "backup";

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  slay.desktop.enable = true;
  slay.bitwarden.enable = true;
  slay.hardware.bluetooth.enable = true;
  slay.hardware.uhk.enable = true;
  slay.hardware.esp32.enable = true;
  slay.ghostty.enable = false;
  #slay.hyprland.enable = true;
  slay.cloudflare-warp.enable = true;
  slay.vpn.enable = false;
  slay.yubikey.enable = true;
  security.sudo.wheelNeedsPassword = false;
  services.printing.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no"; 
    };
    openFirewall = true;
  };
  services.fprintd.enable = true;
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    gdm.fprintAuth = true;
  };
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${systemConfig.user.username} = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = systemConfig.user.authorizedKeys;
    description = "reyess";
    initialPassword = "test";
    group = "${systemConfig.user.username}";
    extraGroups = systemConfig.user.extraGroups;
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
  users.groups.reyess = {};

  networking.resolvconf.dnsExtensionMechanism = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["reyess"];

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
    opentofu
    tofu-ls
    qemu
    wget
    unzip
    coreutils
    wireguard-ui
    yarn
    nodejs_22
    ffmpeg
    fprintd
    libfprint
  ];

  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  system.stateVersion = "24.11";
}
