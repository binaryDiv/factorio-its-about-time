-- TODO: Automatically open/close the clock for players when they join, change their player settings, etc...
-- TODO: on_init, on_configuration_changed, on_runtime_mod_setting_changed, on_player_created, ...

-- Event listener for the "Toggle clock GUI" keyboard shortcut
script.on_event("itsabouttime-toggle-gui", function(event)
    local player = game.players[event.player_index]
    toggle_clock_gui(player)
end)

-- TODO: Update rate: What's a good value? Does it make sense to have a dynamic update rate based on the planet's day
--       length and the player's precision settings? If it's static, do we need a game setting for it?
local CLOCK_UPDATE_RATE = 4

script.on_nth_tick(CLOCK_UPDATE_RATE, function()
    for _, player in pairs(game.players) do
        -- TODO: Only update the time every nth ticks. Update location only when the surface changed.
        -- TODO: (Either use on_player_surface_changed or similar, or save the last known surface in the mod storage
        --       and compare it in every update call. Also check on_space_platform_changed_state.)
        update_clock_location(player)
        update_clock_time(player)
    end
end)
