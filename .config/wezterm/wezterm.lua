-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.default_prog = { 'nu', '-l' }

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
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    {
        key = 'v',
        mods = 'LEADER',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'c',
        mods = 'LEADER',
        action = wezterm.action.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 't',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
        key = 'e',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
        key = 'u',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
        key = 'i',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Down',
    },
    {
        key = 'n',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(-1)
    },
    {
        key = 'r',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(1)
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ShowLauncher
    },
    {
        key = 'g',
        mods = 'LEADER',
        action = wezterm.action.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
    {
        key = 'x',
        mods = 'LEADER',
        action = wezterm.action.ActivateCopyMode
    },
    {
        key = 'q',
        mods = 'LEADER',
        action = wezterm.action.QuickSelect
    },
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
config.font_size = 9.5

config.freetype_load_target = "HorizontalLcd"

config.color_scheme = 'Catppuccin Macchiato'

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- SSH
config.mux_env_remove = {
    "SSH_CLIENT",
    "SSH_CONNECTION",
}

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
local ticket_re = [[TTS?-\d+]]
table.insert(config.hyperlink_rules, {
    regex = ticket_re,
    format = 'https://support.tracetronic.com/browse/$0',
})

-- QuickSelect
config.quick_select_patterns = {
    ticket_re,
}

return config
