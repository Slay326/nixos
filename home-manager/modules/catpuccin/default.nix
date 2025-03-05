{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.catppuccin;
in {
  options.catppuccin = {
    enable = mkEnableOption "Catppuccin theming";
    flavour = mkOption {
      type = types.enum ["latte" "frappe" "macchiato" "mocha"];
      default = "mocha";
      description = "Catppuccin flavour to use";
    };
    accent = mkOption {
      type = types.enum ["rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender"];
      default = "mauve";
      description = "Accent color to use";
    };
    hyprland.enable = mkEnableOption "Catppuccin for Hyprland";
    hyprlock.enable = mkEnableOption "Catppuccin for Hyprlock";
  };

  config = mkIf cfg.enable {
    stylix.targets = {
      hyprland.enable = mkIf cfg.hyprland.enable false;
      hyprlock.enable = mkIf cfg.hyprlock.enable false;
    };
  };
}
