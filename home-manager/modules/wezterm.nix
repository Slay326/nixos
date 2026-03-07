{...}: {
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      local wezterm = require("wezterm")

      return {
        hide_tab_bar_if_only_one_tab = true,


        font = wezterm.font_with_fallback({
          "JetBrainsMono Nerd Font",
          "Apple Color Emoji",
          "Noto Color Emoji",
        }),

        font_size = 14.0,
      }
    '';
  };

  # Alternate terminal emulator
  programs.alacritty.enable = true;
}
