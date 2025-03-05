{
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Definiere den Hintergrund direkt oder importiere ihn von woanders
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/landscapes/forrest.png";
    sha256 = "sha256-jDqDj56e9KI/xgEIcESkpnpJUBo6zJiAq1AkDQwcHQM="; # Hier kommt der korrekte Hash nach dem ersten Build-Versuch
  };

  # Der Abstand zwischen Fenstern für Hyprland und Waybar
  windows_space_gap = 15;
in {
  home.packages = with pkgs; [
    hyprshot
    brightnessctl
    wl-clipboard
    wlsunset
    swww
    alacritty
    yazi
    rofi
    swayosd
  ];

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 180;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 300;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        monitor = "";
        blur_passes = 2;
        path = "${wallpaper}";
      };

      general = {
        hide_cursor = false;
      };

      input-field = {
        monitor = "";
        size = "80px, 60px";
        outline_thickness = 3;
        fade_on_empty = false;
        rounding = 15;

        position = "0, -50";
        halign = "center";
        valign = "center";

        # Einfache Farben für das Eingabefeld
        outer_color = "rgb(180, 190, 254)";
        inner_color = "rgb(30, 30, 46)";
        font_color = "rgb(205, 214, 244)";
        check_color = "rgb(180, 190, 254)";
        fail_color = "rgb(243, 139, 168)";
      };

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%A, %B %d\")\"";
          color = "#FFFFFF";
          font_size = 24;
          font_family = "Noto Sans";
          position = "0, 220";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%-I:%M\")\"";
          color = "#FFFFFF";
          font_size = 96;
          font_family = "Noto Sans";
          position = "0, 120";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprtrails
      csgo-vulkan-fix
      hyprwinwrap
    ];
    settings = {
      "$terminal" = "alacritty";
      "$filemanager" = "yazi";
      "$menu" = "rofi -show drun";

      "monitor" = ",1920x1200@165.00,auto,1";
      "exec-once" = [
        "$terminal"
        "waybar"
        "wlsunset -S 5:30 -s 18:30"
        "swayosd-server"
        "swww-daemon & sleep 0.1 && swww img ${wallpaper}"
      ];

      "env" = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,catppuccin-mocha-mauve-cursors"

        # For Qt
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      ];

      general = {
        gaps_in = 5;
        gaps_out = windows_space_gap;
        border_size = 2;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";

        # Catppuccin Farbschema direkt verwenden
        "col.active_border" = "rgba(180, 190, 254, 1.0) rgba(244, 219, 214, 1.0) 45deg";
        "col.inactive_border" = "rgba(24, 24, 37, 1.0)";
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow.range = 4;
        shadow.render_power = 3;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "de"; # Für deutsches Tastaturlayout
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = false;
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      plugin = {
        hyprtrails = {
          color = "rgba(180, 190, 254, 1.0)"; # Catppuccin mauve
        };
        hyprwinwrap = {
          class = "backgroundapp";
        };
      };

      "$mainMod" = "ALT";

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, W, killactive,"
        "$mainMod CTRL, Q, exit,"
        "$mainMod, E, exec, $terminal -e $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, F, fullscreen, 1"
        "$mainMod, M, fullscreen, 0"
        ", Print, exec, hyprshot -m region"
        "$mainMod, Print, exec, hyprshot -m output"

        "$mainMod, L, exec, hyprlock"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Laptop multimedia keys for volume and LCD brightness
      bindel = [
        ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"

        ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
    xwayland.enable = true;
  };

  programs.waybar = {
    enable = true;
    style = ''
      /* Catppuccin Mocha-Farbschema */
      @define-color base #1e1e2e;
      @define-color mantle #181825;
      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;
      @define-color text #cdd6f4;
      @define-color rosewater #f5e0dc;
      @define-color lavender #b4befe;
      @define-color red #f38ba8;
      @define-color peach #fab387;
      @define-color yellow #f9e2af;
      @define-color green #a6e3a1;
      @define-color teal #94e2d5;
      @define-color blue #89b4fa;
      @define-color mauve #cba6f7;
      @define-color flamingo #f2cdcd;

      * {
        color: @text;
        font-family: "Noto Sans";
        font-weight: bold;
        font-size: 14px;
      }

      window#waybar {
        background-color: rgba(0, 0, 0, 0);
      }

      #waybar > box {
        margin: 10px ${toString windows_space_gap}px 0px;
        background-color: @base;
        border: 2px solid @mauve;
      }

      #workspaces,
      #window,
      #idle_inhibitor,
      #wireplumber,
      #network,
      #cpu,
      #memory,
      #battery,
      #clock,
      #power-profiles-daemon,
      #tray,
      #waybar > box {
        border-radius: 12px;
      }

      #workspaces * {
        color: @red;
      }

      #window * {
        color: @mauve;
      }

      #clock {
        color: @peach;
      }

      #idle_inhibitor {
        color: @yellow;
      }

      #wireplumber {
        color: @green;
      }

      #network {
        color: @teal;
      }

      #power-profiles-daemon {
        color: @blue;
      }

      #battery {
        color: @lavender;
      }

      #tray {
        color: @text;
      }

      #idle_inhibitor,
      #wireplumber,
      #network,
      #cpu,
      #memory,
      #battery,
      #clock,
      #power-profiles-daemon,
      #tray {
        padding: 0 5px;
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 4;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "idle_inhibitor"
          "wireplumber"
          "network"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          warp-on-scroll = false;
          format = "{name}: {icon}";
          format-icons = {
            "urgent" = "";
            "active" = "";
            "default" = "";
          };
        };

        idle_inhibitor = {
          format = "Idle: {icon} ";
          format-icons = {
            "deactivated" = "";
            "activated" = "";
          };
        };

        wireplumber = {
          format = "Volume: {icon}  {volume}% ";
          format-icons = ["" "" ""];
          format-muted = "Muted ";
        };

        clock = {
          format = "  {:%H:%M}";
        };

        network = {
          format = "  {essid} 󰓅 {signalStrength}";
        };

        battery = {
          format-icons = ["" "" "" "" ""];
          format = "{icon}  {capacity}%";
        };
      };
    };
  };

  # Stateversion für Home Manager
  home.stateVersion = "24.11";
}
