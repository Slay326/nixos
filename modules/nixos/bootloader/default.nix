{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.bootloader;
in {
  options.slay.bootloader = {
    enable = lib.mkEnableOption "Enable bootloader configuration";

    flavor = lib.mkOption {
      type = lib.types.enum ["systemd-boot" "grub"];
      default = "systemd-boot";
      description = "Which bootloader to configure on this host.";
    };

    grub = {
      useOSProber = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Detect other OSes (e.g. Windows) via os-prober.";
      };

      timeout = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "GRUB timeout in seconds.";
      };

      timeoutStyle = lib.mkOption {
        type = lib.types.enum ["menu" "hidden" "countdown"];
        default = "menu";
        description = "GRUB timeout style.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.efi.canTouchEfiVariables = true;

    boot.loader.systemd-boot = lib.mkMerge [
      {enable = cfg.flavor == "systemd-boot";}
      (lib.mkIf (cfg.flavor == "systemd-boot") {
        editor = false;
        configurationLimit = 20;
        memtest86.enable = true;
        netbootxyz.enable = true;
        edk2-uefi-shell.enable = true;
      })
    ];

    boot.loader.grub = lib.mkMerge [
      {enable = cfg.flavor == "grub";}
      (lib.mkIf (cfg.flavor == "grub") {
        efiSupport = true;
        device = "nodev";
        useOSProber = cfg.grub.useOSProber;
        timeout = cfg.grub.timeout;
        timeoutStyle = cfg.grub.timeoutStyle;
      })
    ];
  };
}
