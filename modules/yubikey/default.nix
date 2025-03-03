{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.yubikey;
in {
  options.slay.yubikey = {
    enable = lib.mkEnableOption "Enable YubiKey Support";
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];

    # Smartcard support
    services.pcscd.enable = true;

    # Management GUI
    environment.systemPackages = with pkgs; [
      yubioath-flutter
    ];
  };
}
