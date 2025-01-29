-- Add a custom keyboard shortcut to toggle whether the GUI is visible. (Mostly helpful for debugging.)
-- TODO: How does this relate to the "show-clock" player setting?
-- TODO: Localise!
data:extend({
    {
        type = "custom-input",
        name = "itsabouttime-toggle-gui",
        -- Don't set a default key binding for now, but allow players to set one.
        key_sequence = "",
        action = "lua",
    },
})
