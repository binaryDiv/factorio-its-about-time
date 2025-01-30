-- Return the clock GUI of the given player (or nil if there is no GUI)
function get_clock_gui(player)
    return player.gui.top.itsabouttime_clock
end

-- Return the label GUI element that shows the time (assumes the GUI is open!)
function get_clock_gui_time_label(player)
    return get_clock_gui(player).time_label
end

-- Return the choose-elem-button GUI element that shows the current planet (assumes the GUI is open!)
function get_clock_gui_planet_button(player)
    return get_clock_gui(player).planet_button
end

-- Return the sprite button GUI element that is used when the current surface is not a planet (assumes the GUI is open!)
function get_clock_gui_misc_sprite_button(player)
    return get_clock_gui(player).misc_sprite_button
end

-- Create the clock GUI for the given player if it doesn't exist yet
function open_clock_gui(player)
    -- If the GUI is already open, close it first and then recreate it to make sure the layout is up to date
    if get_clock_gui(player) then
        close_clock_gui(player)
    end

    -- Create the frame that contains the GUI elements of the clock
    local clock_frame = player.gui.top.add {
        type = "frame",
        name = "itsabouttime_clock",
        style = "itsabouttime-clock-frame",
    }

    -- Create sprite button that can be used to display icons if the current location is not a valid space location.
    local misc_sprite_button = clock_frame.add {
        type = "sprite-button",
        name = "misc_sprite_button",
        style = "slot_button",
        sprite = nil,
        visible = false,
    }

    -- Create button that displays the current planet. This is not a regular sprite button but a locked choose-elem
    -- button, which allows the player to alt-click it to open the Factoriopedia page on the planet.
    local planet_button = clock_frame.add {
        type = "choose-elem-button",
        name = "planet_button",
        elem_type = "space-location",
    }
    planet_button.locked = true

    -- Create label that displays the time
    local time_label = clock_frame.add {
        type = "label",
        name = "time_label",
        style = "itsabouttime-time-label",
        caption = "00:00",
    }

    -- Update the location and time
    update_clock(player)
end

-- Close the clock GUI of the given player (if it exists)
function close_clock_gui(player)
    if not get_clock_gui(player) then
        return
    end

    get_clock_gui(player).destroy()
end

-- Open or close the clock GUI for a player depending on the player settings. Recreate GUI if its already open.
function open_or_close_clock_gui(player)
    if not player.valid then
        return
    end

    -- Close GUI if it is already open (to force recreating the GUI)
    close_clock_gui(player)

    -- Only open the GUI if the "show-clock" setting is enabled
    if get_player_setting_show_clock(player) then
        open_clock_gui(player)
    end
end

-- Set the time label in a player's clock GUI to a string
function set_clock_time(player, time_str, freeze_daytime)
    if not get_clock_gui(player) then
        return
    end

    local time_label = get_clock_gui_time_label(player)

    -- If the time is frozen (which is often the case on non-planet surfaces, like Blueprint Sandbox surfaces,
    -- Factorissimo surfaces or even on space platforms), indicate that by using gray color and an explanatory tooltip.
    if freeze_daytime then
        time_label.caption = "[color=#7f7f7f]" .. time_str .. "[/color]"
        -- TODO: Localise!
        time_label.tooltip = "The flow of time is frozen on this plane of existence."
    else
        time_label.caption = time_str
        time_label.tooltip = nil
    end
end

-- Set the icon and tooltip of the planet button in the clock GUI
function set_clock_planet(player, planet_name, tooltip)
    if not get_clock_gui(player) then
        return
    end

    local planet_button = get_clock_gui_planet_button(player)

    -- If planet is nil, hide the planet button
    if planet_name == nil then
        planet_button.visible = false
        planet_button.elem_value = nil
        planet_button.tooltip = nil
    else
        planet_button.visible = true
        planet_button.elem_value = planet_name
        planet_button.tooltip = tooltip
    end
end

-- Set the sprite of the "miscellaneous sprite button" (used to indicate non-planet surfaces) in the clock GUI
function set_clock_misc_sprite(player, sprite_path, tooltip)
    if not get_clock_gui(player) then
        return
    end

    local sprite_button = get_clock_gui_misc_sprite_button(player)

    -- If the sprite path is nil, hide the sprite button
    if sprite_path == nil then
        sprite_button.visible = false
        sprite_button.sprite = nil
        sprite_button.tooltip = nil
    else
        -- Check if the sprite path exists
        if not helpers.is_valid_sprite_path(sprite_path) then
            sprite_path = "utility/questionmark"
        end
        sprite_button.visible = true
        sprite_button.sprite = sprite_path
        sprite_button.tooltip = tooltip
    end
end
