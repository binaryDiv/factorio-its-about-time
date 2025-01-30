-- Helper functions to read mod settings

-- Read player setting: Should the clock GUI be visible?
function get_player_setting_show_clock(player)
    local setting = player.valid and player.mod_settings["itsabouttime-show-clock"]
    return setting and setting.value == true
end

-- Write player setting: Toggle whether the clock GUI should be visible or not
function toggle_player_setting_show_clock(player)
    if not player.valid then
        return
    end

    -- Get current value of setting
    local current_value = player.mod_settings["itsabouttime-show-clock"].value

    -- Set new value by inverting the value
    player.mod_settings["itsabouttime-show-clock"] = { value = not current_value }
end

-- Read player setting: Clock precision (returned as an integer or the string "auto")
function get_player_setting_clock_precision(player)
    local precision = player.mod_settings["itsabouttime-clock-precision"].value
    if precision == "auto" then
        return "auto"
    else
        return tonumber(precision)
    end
end
