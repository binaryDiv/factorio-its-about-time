-- Mod initialization (called when starting a new game or adding the mod to an existing save)
script.on_init(function()
    -- Open clock GUI for all players (if the "show-clock" player setting is enabled)
    for _, player in pairs(game.players) do
        open_or_close_clock_gui(player)
    end
end)

-- Event that is called when the game's configuration has changed, which includes: Startup mod settings were changed,
-- the game was updated, any mod was added, removed or updated.
script.on_configuration_changed(function()
    -- The mod might have been added to an existing game, or it was updated, or maybe something else has changed.
    -- In any case, open/close/recreate the GUI for all players (if the "show-clock" player setting is enabled).
    for _, player in pairs(game.players) do
        open_or_close_clock_gui(player)
    end
end)

-- Event that is called when a (player or map) runtime setting has been changed
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    -- Open or close the GUI if the player changed the "show-clock" setting
    if event.setting == "itsabouttime-show-clock" then
        local player = game.players[event.player_index]
        open_or_close_clock_gui(player)
    end
end)

-- Event that is called when a new player is created (i.e. joins the game for the first time)
script.on_event(defines.events.on_player_created, function(event)
    -- Open clock GUI for the new player (if the "show-clock" player setting is enabled)
    local player = game.players[event.player_index]
    open_or_close_clock_gui(player)
end)

-- Event listener for the "Toggle clock GUI" keyboard shortcut
script.on_event("itsabouttime-toggle-gui", function(event)
    local player = game.players[event.player_index]

    -- Toggle the player's "show-clock" mod setting. This will automatically raise an `on_runtime_mod_setting_changed`
    -- event, so we don't need to open/close the GUI here.
    toggle_player_setting_show_clock(player)
end)


-- TODO: Update rate: What's a good value? Does it make sense to have a dynamic update rate based on the planet's day
--       length and the player's precision settings? If it's static, do we need a game setting for it?
local CLOCK_UPDATE_RATE = 4

script.on_nth_tick(CLOCK_UPDATE_RATE, function()
    for _, player in pairs(game.players) do
        -- Only update the time, since changes in the location don't happen that often and can be handled via events.
        update_clock_time(player)
    end
end)


-- Events that are called in various situations that should update the location shown in the clock GUI
function handle_change_location(event)
    local players = game.players

    -- If the event is triggered for a specific player, only update the clock location for this player.
    if event.player_index ~= nil then
        players = { players[event.player_index] }
    end

    for _, player in pairs(players) do
        -- Update location AND time, because the time is location-dependent
        update_clock(player)
    end
end

script.on_event(defines.events.on_player_changed_surface, handle_change_location)
script.on_event(defines.events.on_space_platform_changed_state, handle_change_location)
script.on_event(defines.events.on_surface_created, handle_change_location)
