# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-db6649a5-d532-4d97-b7db-21c52c7f4157".device = "/dev/disk/by-uuid/db6649a5-d532-4d97-b7db-21c52c7f4157";
  networking.hostName = "nb-6462"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;
  home-manager.backupFileExtension = "backup";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  slay.desktop.enable = true;
  slay.bitwarden.enable = true;
  slay.hardware.bluetooth.enable = true;
  slay.hardware.uhk.enable = true;
  slay.hardware.esp32.enable = true;
  #slay.hyprland.enable = true;
  slay.cloudflare-warp.enable = true;
  security.sudo.wheelNeedsPassword = false;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # Nur SSH-Keys erlauben
      PermitRootLogin = "no"; # Root-Login verhindern
    };
    openFirewall = true; # Falls du eine Firewall nutzt, öffne Port 22
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["reyess"];

  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    vscode
    git
    obsidian
    termius
    spotify
    desktop-file-utils
    colmena
    dbeaver-bin
    cinny-desktop
    terraform
  ];

  # XDG Portale - wichtig für Wayland-Integration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
