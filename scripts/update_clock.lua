-- Update location and time in a player's clock GUI
function update_clock(player)
    update_clock_location(player)
    update_clock_time(player)
end

-- Update the player's location in the clock GUI (e.g. the planet or space platform)
-- (This does *not* update the time. When the location changes, update_clock() should be used instead.)
function update_clock_location(player)
    -- Don't do anything if the clock GUI is not open
    if not get_clock_gui(player) then
        return
    end

    local surface = player.surface
    local space_location = get_effective_space_location(surface)

    if space_location then
        -- If the player is on a planet or on a platform orbiting a space location, show its icon and tooltip.
        set_clock_misc_sprite(player, nil)
        set_clock_planet(player, space_location.name, get_space_location_tooltip(space_location))
    elseif surface.platform then
        -- If the platform is not stopped at a space location, show the Space Age icon instead.
        set_clock_planet(player, nil)
        set_clock_misc_sprite(player, "utility/space_age_icon", { "itsabouttime.location-tooltip-in-space" })
    else
        -- Player is on a surface that's neither a planet nor a space platform (e.g. a Blueprint Sandbox surface)
        local misc_sprite_path = "utility/questionmark"
        local misc_sprite_tooltip = { "itsabouttime.location-tooltip-unknown-surface" }

        -- Check for surfaces provided by supported mods and show their icon and a fitting tooltip
        -- (We could additionally check if the mod is actually installed to avoid coincidental matches, but those are
        -- unlikely, and we check the validity of the sprite path anyway to avoid crashes, so we won't do that.)
        if string_starts_with(surface.name, "bpsb-lab-") then
            -- Lab surface from the mod "Blueprint Sandboxes"
            misc_sprite_path = "item-group/blueprint-sandboxes"
            misc_sprite_tooltip = { "itsabouttime.location-tooltip-blueprint-sandbox" }
        elseif string_starts_with(surface.name, "drawing-board_") then
            -- Lab surface from the mod "Drawing Board"
            misc_sprite_path = "shortcut/drawing-board-setup"
            misc_sprite_tooltip = { "itsabouttime.location-tooltip-drawing-board" }
        elseif string_starts_with(surface.name, "proc_") then
            -- Circuit surface from the mod "Compact circuits"
            misc_sprite_path = "entity/compaktcircuit-processor"
            misc_sprite_tooltip = { "itsabouttime.location-tooltip-compact-circuits" }
        end

        set_clock_planet(player, nil)
        set_clock_misc_sprite(player, misc_sprite_path, misc_sprite_tooltip)
    end
end

-- Update the current time on a player's clock
function update_clock_time(player)
    -- Ignore call if the clock GUI is not open
    if not get_clock_gui(player) then
        return
    end

    -- Get the effective surface, i.e. the surface that determines which time is displayed
    local effective_surface = get_effective_surface_for_time(player.surface)

    if effective_surface.platform ~= nil then
        -- Player is on a space platform that is *not* orbiting a planet with a surface. There is no time.
        set_clock_time(player, { "itsabouttime.time-caption-space" })
    else
        -- Player is either on a planet, a space platform orbiting a planet, or some other kind of surface.

        -- Read player settings to determine the clock precision
        local precision = get_player_setting_clock_precision(player)

        if precision == "auto" then
            -- Dynamic precision: Calculate optimal precision depending on the length of a day on the planet
            precision = calculate_dynamic_clock_precision(effective_surface)
        end

        local time_str = convert_daytime_to_str(effective_surface.daytime, precision)
        set_clock_time(player, time_str, effective_surface.freeze_daytime)
    end
end

-- Determine the effective surface for displaying time on the given surface. For example, if the surface is a space
-- platform orbiting a planet, the surface of that planet is returned. Otherwise, the same surface is returned (e.g.
-- if the surface already is a planet, or a space platform mid-flight, or some other kind of surface created by a mod.
function get_effective_surface_for_time(surface)
    if string_ends_with(surface.name, "-factory-floor") then
        -- Factorissimo support: Show time of the actual planet, not the factory floor (which is always frozen at 12:00)
        local planet_name = string_remove_suffix(surface.name, "-factory-floor")

        if game.surfaces[planet_name] ~= nil then
            return game.surfaces[planet_name]
        else
            -- Fallback to returning the surface itself if the planet's surface doesn't exist
            return surface
        end
    elseif surface.planet ~= nil then
        -- If it's the surface of a planet, return the same surface.
        return surface
    elseif surface.platform ~= nil then
        -- The surface is a space platform. Check whether it's orbiting a planet with a surface.
        local space_location = surface.platform.space_location

        if space_location ~= nil and game.surfaces[space_location.name] ~= nil then
            -- If the platform is orbiting a planet with a surface, return the planet's surface.
            return game.surfaces[space_location.name]
        else
            -- Otherwise, the platform is either in flight, orbiting an undiscovered planet (the surface is only
            -- generated the first time you land), or orbiting a space location that is not a planet.
            -- In all these cases, just return the surface of the space platform.
            return surface
        end
    else
        -- Any other kind of surface, e.g. a Blueprint Sandbox (mod) surface. Just return it.
        return surface
    end
end

-- Return the space location that should be displayed in the clock depending on the current surface. For example, if the
-- surface is a space platform that is stopped at a space location, return that space location. If there is no space
-- location, return nil.
function get_effective_space_location(surface)
    -- Factorissimo support: Show the actual planet, not the factory floor "planet"
    if string_ends_with(surface.name, "-factory-floor") then
        local planet_name = string_remove_suffix(surface.name, "-factory-floor")

        if game.planets[planet_name] ~= nil then
            return game.planets[planet_name].prototype
        end
        -- If the planet doesn't exist, fallback to the default behavior and return the factory floor planet
    end

    if surface.planet ~= nil then
        -- The surface belongs to a planet (i.e. space location)
        return surface.planet.prototype
    elseif surface.platform ~= nil and surface.platform.space_location ~= nil then
        -- The surface is a space platform that is stopped at a space location
        return surface.platform.space_location
    else
        -- Either a space platform mid-flight or any other kind of surface, so there is no space location
        return nil
    end
end

-- Generate the tooltip for the given space location, containing information about the planet's daytimes if available
function get_space_location_tooltip(space_location)
    if space_location.type == "planet" then
        local planet_surface = game.surfaces[space_location.name]
        local planet_data_tooltip

        -- Add some additional data about the day times on the planet if it already has a surface.
        -- If the planet doesn't have a surface yet, that likely means the player has not landed on it yet.
        if planet_surface ~= nil then
            planet_data_tooltip = {
                "itsabouttime.location-tooltip-planet-data",
                convert_daytime_to_str(planet_surface.morning, 5),
                convert_daytime_to_str(planet_surface.dawn, 5),
                convert_daytime_to_str(planet_surface.dusk, 5),
                convert_daytime_to_str(planet_surface.evening, 5),
            }
        else
            planet_data_tooltip = { "itsabouttime.location-tooltip-planet-no-data" }
        end

        -- Concatenate localised strings: Planet title and additional daytime data
        return {
            "",
            { "itsabouttime.location-tooltip-planet-title", space_location.localised_name },
            "\n",
            planet_data_tooltip,
        }
    else
        return { "itsabouttime.location-tooltip-space-location", space_location.localised_name }
    end
end
