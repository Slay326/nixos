{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.slay.hyprland;
  hyprlandFlake = inputs.hyprland.packages.${pkgs.system}.hyprland;
  oxocarbon_pink = "ff7eb6";
  oxocarbon_border = "393939";
  oxocarbon_background = "161616";
  background = "rgba(11111B00)";
  tokyonight_border = "rgba(7aa2f7ee) rgba(87aaf8ee) 45deg";
  tokyonight_background = "rgba(32344aaa)";
  catppuccin_border = "rgba(b4befeee)";
  opacity = "0.95";
  transparent_gray = "rgba(666666AA)";
  gsettings = "${pkgs.glib}/bin/gsettings";
  gnomeSchema = "org.gnome.desktop.interface";
in {
  options.slay.hyprland = {
    enable = lib.mkEnableOption "Enable hyprland";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
    home = toString ./home-manager/default.nix;
    slay.home-manager.homeModule = {
  path = toString ./home-manager/default.nix;
    packages = with pkgs; [
      grim # Screenshot tool for hyprland
      slurp # Works with grim to screenshot on wayland
      swappy # Wayland native snapshot editing tool, inspired by Snappy on macOS
      wl-clipboard # Enables copy/paste on wayland
      nwg-look # Change GTK theme
      glib # Needed for gsettings

      (writeShellScriptBin "screenshot" ''
        grim -g "$(slurp)" - | wl-copy
      '')

      (writeShellScriptBin "screenshot-edit" ''
        wl-paste | swappy -f -
      '')

      (writeShellScriptBin "autostart" ''
        # Variables
        config=$HOME/.config/hypr
        scripts=$config/scripts

        # Waybar (if enabled)
        pkill waybar
        $scripts/launch_waybar &
        $scripts/tools/dynamic &

        # ags (bar and some extra stuff)
        ags

        # Wallpaper
        swww kill
        swww init
        swww restore

        # Others
        /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
        # dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
      '')

      (writeShellScriptBin "importGsettings" ''
        config="/home/redyf/.config/gtk-3.0/settings.ini"
        if [ ! -f "$config" ]; then exit 1; fi
        gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
        icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
        cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
        font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
        ${gsettings} set ${gnomeSchema} gtk-theme "$gtk_theme"
        ${gsettings} set ${gnomeSchema} icon-theme "$icon_theme"
        ${gsettings} set ${gnomeSchema} cursor-theme "$cursor_theme"
        ${gsettings} set ${gnomeSchema} font-name "$font_name"
      '')
    ];
    }
    programs.xwayland = {
      enable = true;
      # package = nixpkgs-stable.legacyPackages.x86_64-linux.hyprland; # hyprlandFlake or pkgs.hyprland
      package = hyprlandFlake; # hyprlandFlake or pkgs.hyprland
      # Submaps
      # extraConfig = [
      #        source = ~/.config/hypr/themes/catppuccin-macchiato.conf
      #        source = ~/.config/hypr/themes/oxocarbon.conf
      #        env = GBM_BACKEND,nvidia-drm
      #        env = LIBVA_DRIVER_NAME,nvidia
      #        env = XDG_SESSION_TYPE,wayland
      #        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      #        # will switch to a submap called resize
      #        bind=$mainMod,R,submap,resize
      #
      #        # will start a submap called "resize"
      #        submap=resize
      #
      #        # sets repeatable binds for resizing the active window
      #        binde=,L,resizeactive,15 0
      #        binde=,H,resizeactive,-15 0
      #        binde=,K,resizeactive,0 -15
      #        binde=,J,resizeactive,0 15
      #
      #        # use reset to go back to the global submap
      #        bind=,escape,submap,reset
      #        bind=$mainMod,R,submap,reset
      #
      #        # will reset the submap, meaning end the current one and return to the global one
      #        submap=reset
      # ];
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = with pkgs; xdg-desktop-portal-hyprland;
    };
  };
}
