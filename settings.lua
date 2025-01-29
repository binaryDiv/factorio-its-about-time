-- Define mod settings
data:extend({
    -- Per player setting: Whether to show the clock
    -- TODO: Localise!
    {
        type = "bool-setting",
        name = "itsabouttime-show-clock",
        setting_type = "runtime-per-user",
        default_value = true,
    }
})
