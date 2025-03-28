{
  lib,
  pkgs,
  config,
  ...
}: {
  # https://nix.dev/guides/faq.html#how-to-run-non-nix-executables
  programs.nix-ld = lib.mkIf config.slay.desktop.enable {
    enable = true;
    libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
      libsecret
    ];
  };
}
