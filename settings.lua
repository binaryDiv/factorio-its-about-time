-- Define mod settings
data:extend({
    -- Per player setting: Whether to show the clock
    -- TODO: Localise!
    {
        setting_type = "runtime-per-user",
        name = "itsabouttime-show-clock",
        order = "1-show-clock",
        type = "bool-setting",
        default_value = true,
    },

    -- Per player setting: Clock precision in minutes (or auto mode)
    -- TODO: Localise!
    {
        setting_type = "runtime-per-user",
        name = "itsabouttime-clock-precision",
        order = "2-clock-precision",
        type = "string-setting",
        default_value = "10",
        allowed_values = { "auto", "1", "5", "10", "15" },
    },
})
