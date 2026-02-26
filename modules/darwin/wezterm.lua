local wezterm = require("wezterm")
local act = wezterm.action

local GLASS = {
    opacity = 0.82,
    blur = 35
}
local SOLID = {
    opacity = 1.0,
    blur = 0
}

wezterm.on("toggle-glass", function(window, _pane)
    local overrides = window:get_config_overrides() or {}

    -- Determine "is_glass" from overrides if present,
    -- otherwise fall back to the default config values.
    local opacity = overrides.window_background_opacity
    if opacity == nil then
        opacity = GLASS.opacity -- this matches your default config
    end

    local is_glass = opacity < 1.0
    local target = is_glass and SOLID or GLASS

    overrides.window_background_opacity = target.opacity
    overrides.macos_window_background_blur = target.blur
    window:set_config_overrides(overrides)
end)

return {
    window_decorations = "RESIZE",
    enable_tab_bar = false,

    window_background_opacity = GLASS.opacity,
    macos_window_background_blur = GLASS.blur,

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
        background = "#0b0f14"
    }
}
