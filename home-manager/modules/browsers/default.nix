{
  pkgs,
  lib,
  ...
}: let
  args = [
    # Chromium Wayland is broken, see https://github.com/NixOS/nixpkgs/issues/334175
    #"--enable-features=UseOzonePlatform,VaapiVideoDecodeLinuxGL"
    #"--ozone-platform=wayland"

    # Deine Flags
    "--ignore-gpu-blocklist"
    "--enable-zero-copy"
  ];
in {
  home.packages = [
    # https://discourse.nixos.org/t/google-chrome-not-working-after-recent-nixos-rebuild/43746/8
    (pkgs.google-chrome.override {
      commandLineArgs = args;
    })

    # microsoft-edge # edge is totally borked right now
  ];
  programs.firefox = {
    enable = true;
    #package = pkgs.firefox-nightly-bin;

    profiles.default = {
      settings = {
        "widget.wayland.enabled" = true;
        "gfx.webrender.enabled" = true;
        "gfx.webrender.all" = false;
        "layers.gpu-process.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "browser.tabs.unloadOnLowMemory" = true;
        "browser.low_commit_space_threshold_mb" = 512;
        "browser.sessionstore.resume_from_crash" = true;
        "browser.startup.page" = 3;
      };
    };
  };
  stylix.targets.firefox.profileNames = ["default"];

  # Chromium (bei dir: Brave als chromium package)
  programs.chromium = {
    enable = true;
    package = pkgs.brave.override {
      commandLineArgs = args;
    };

    extensions = [
      # Bypass Paywalls Chrome Clean
      {
        id = "lkbebcjgcmobigpeffafkodonchffocl";
        updateUrl = "https://gitlab.com/magnolia1234/bypass-paywalls-chrome-clean/-/raw/master/updates.xml";
      }
      # AdNauseam
      {
        id = "dkoaabhijcomjinndlgbmfnmnjnmdeeb";
        updateUrl = "https://rednoise.org/adnauseam/updates.xml";
      }
      # Bitwarden
      {
        id = "nngceckbapebfimnlniiiahkandclblb";
      }
    ];
  };
}
