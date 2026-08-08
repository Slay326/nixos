{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.slay.android;
  activeUser = config.slay.activeUser;

  defaultSdkPackages = {
    includeEmulator = cfg.emulator.enable;
    includeSystemImages = cfg.emulator.enable;
    systemImageTypes = ["google_apis_playstore"];
    abiVersions = ["x86_64"];
    buildToolsVersions = ["latest"];
    platformVersions = ["latest"];
  };

  androidComposition = pkgs.androidenv.composeAndroidPackages (defaultSdkPackages // cfg.sdkPackages);
  # The composed SDK exposes adb, emulator, sdkmanager, and avdmanager through bin/.
  androidSdk = androidComposition.androidsdk;
  androidEnvironment = {
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
  };
in {
  options.slay.android = {
    enable = lib.mkEnableOption "Enable Android SDK and emulator tooling";

    emulator.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Android Emulator support and grant KVM access to the active user.";
    };

    studio = {
      enable = lib.mkEnableOption "Install Android Studio";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.androidStudioPackages.stable;
        description = "Android Studio package to install when slay.android.studio.enable is set.";
      };
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional Android-related packages to install.";
    };

    sdkPackages = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional arguments passed to pkgs.androidenv.composeAndroidPackages.";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        nixpkgs.config.android_sdk.accept_license = true;

        environment.systemPackages =
          [
            androidSdk
          ]
          ++ cfg.packages
          ++ lib.optional cfg.studio.enable cfg.studio.package;

        environment.sessionVariables = androidEnvironment;
      }

      (lib.mkIf cfg.emulator.enable {
        users.groups.kvm = {};
      })

      (lib.mkIf (cfg.emulator.enable && activeUser != null) {
        users.users.${activeUser.username}.extraGroups = ["kvm"];
      })

      (lib.mkIf (activeUser != null) {
        home-manager.users.${activeUser.username} = {
          home.sessionVariables = androidEnvironment;
          programs.zsh.initContent = ''
            export ANDROID_HOME="${androidEnvironment.ANDROID_HOME}"
            export ANDROID_SDK_ROOT="${androidEnvironment.ANDROID_SDK_ROOT}"
          '';
        };
      })
    ]
  );
}
