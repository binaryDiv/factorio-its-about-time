-- Converts the floating point daytime used by the game to a string in the format "HH:MM". The second parameter sets
-- the precision in minutes. The time converted to minutes will be rounded down to a multiple of this value.
-- Example: 13:37 (precision 1), 13:35 (precision 5), 13:30 (precision 10), 13:00 (precision 60, i.e. only full hours).
function convert_daytime_to_str(time_double, precision)
    -- The in-game times are stored as doubles ranging from 0 to 1 (excl. 1), where 0 is 12:00 and 0.5 is 00:00.
    -- We multiply this value with the amount of minutes per day (24 * 60 = 1440) to get the minutes since 12:00.
    -- Then we add half a day and apply a modulo 1440 (1 day) to normalize the value to get the minutes since 00:00.
    local time_minutes = (math.floor(time_double * 1440) + 720) % 1440

    -- Round value to the specified precision by dividing, rounding down and multiplying again.
    if precision ~= nil and precision > 1 then
        time_minutes = math.floor(time_minutes / precision) * precision
    end

    -- Divide minutes since 00:00 by 60 (rounding down) to get the hours, use modulo 60 to get the minutes.
    local time_h = math.floor(time_minutes / 60)
    local time_m = time_minutes % 60

    return string.format("%02d:%02d", time_h, time_m)
end
