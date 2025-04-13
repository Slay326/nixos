{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.stylix;
in {
  options.slay.stylix = {
    enable = lib.mkEnableOption "Enable Stylix";
  };

  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;

      image = pkgs.fetchurl {
        name = "LilEarth.jpg";
        url = "https://i.redd.it/i1ong1fwrvoe1.png";
        sha256 = "sha256-yuORQ0DbGgylQwp54x7fU5XG1pYEzWFcRrn15P/Ms8E=";
      };

      polarity = "dark";

      base16Scheme = "${pkgs.base16-schemes}/share/themes/purpledream.yaml";

      cursor = {
        name = "breeze_cursors";
        package = pkgs.kdePackages.breeze;
        size = 24;
      };

      fonts = rec {
        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        sansSerif = {
          name = "Noto Sans";
          package = pkgs.noto-fonts;
        };

        # serif fonts suck, just force them to sans-serif
        # ¯\_(ツ)_/¯
        serif = sansSerif;

        sizes = let
          default = 10;
          large = 12;
        in {
          applications = default;
          terminal = large;
          desktop = default;
          popups = default;
        };
      };

      opacity = let
        default = 1.0;
        transparent = 0.9;
      in {
        applications = default;
        terminal = transparent;
        desktop = default;
        popups = transparent;
      };
    };
  };
}
