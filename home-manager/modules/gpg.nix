{
  lib,
  pkgs,
  ...
}: {
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
  programs.gpg = {
    enable = true;
    settings = {
      use-agent = true;
    };
  };
}
