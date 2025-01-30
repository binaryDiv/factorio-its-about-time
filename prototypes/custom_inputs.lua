-- Add a custom keyboard shortcut to toggle whether the GUI is visible. Changes the "show-clock" per-player mod setting.
data:extend({
    {
        type = "custom-input",
        name = "itsabouttime-toggle-gui",
        -- Don't set a default key binding for now, but allow players to set one.
        key_sequence = "",
        action = "lua",
    },
})
