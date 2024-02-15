-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Addons
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

config.keys = {}

workspace_switcher.apply_to_config(config)

workspace_switcher.set_workspace_formatter(function(label)
    return wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Text = "󱂬: " .. label },
    })
end)

-- Keys
config.keys = {
    {
        key = "b",
        mods = "ALT",
        action = workspace_switcher.switch_workspace(),
    }
}

-- General
config.scrollback_lines = 1000000


-- Appearance
config.window_decorations = "RESIZE"

config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 9

config.freetype_load_target = "HorizontalLcd"

config.color_scheme = 'Catppuccin Macchiato'

config.use_fancy_tab_bar = false

-- Socket
config.unix_domains = {
    {
        name = 'unix',
    },
}
config.default_gui_startup_args = { 'connect', 'unix' }


-- Links

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make ticket numbers clickable
table.insert(config.hyperlink_rules, {
    regex = [[TTS-\d+]],
    format = 'https://support.tracetronic.com/browse/$0',
})

return config
