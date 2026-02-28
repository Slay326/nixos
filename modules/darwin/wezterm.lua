local wezterm = require("wezterm")
local act = wezterm.action

local GLASS_OPACITY = 0.82
local GLASS_BLUR = 35

wezterm.on("toggle-glass", function(window, _pane)
    local overrides = window:get_config_overrides()

    if overrides and overrides.window_background_opacity ~= nil then
        window:set_config_overrides({})
    else
        window:set_config_overrides({
            window_background_opacity = 1.0,
            macos_window_background_blur = 0
        })
    end
end)

return {
    window_decorations = "INTEGRATED_BUTTONS|RESIZE",
    enable_tab_bar = false,

    window_frame = {
        active_titlebar_bg = "#0b0f14",
        inactive_titlebar_bg = "#0b0f14"
    },

    window_close_confirmation = "NeverPrompt",
    window_background_opacity = 0.82,
    macos_window_background_blur = 35,

    window_padding = {
        left = 18,
        right = 18,
        top = 14,
        bottom = 14
    },

    front_end = "WebGpu",
    animation_fps = 120,
    max_fps = 120,

    font = wezterm.font_with_fallback({"JetBrainsMono Nerd Font", "SF Mono"}),
    font_size = 14.0,

    default_cursor_style = "BlinkingBar",

    keys = {{
        key = "u",
        mods = "CMD",
        action = act.EmitEvent("toggle-glass")
    }},

    colors = {
        background = "#24273a"
    }
}
