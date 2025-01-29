-- Helper functions to read mod settings

-- Player setting: Should the clock GUI be visible?
function get_player_setting_show_clock(player)
    local player_settings = settings.get_player_settings(player)
    local setting = player_settings.valid and player_settings["itsabouttime-show-clock"]
    return setting and setting.value == true
end
