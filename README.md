# Factorio Mod: It's About Time!

Factorio mod that displays a clock the in-game time on the current planet. 

**Mod portal:** https://mods.factorio.com/mod/its-about-time

You can install the mod using the in-game mod manager, or by downloading it from the mod portal page linked above to your game's `mods` directory.


## Mod description

This mod adds a clock that displays the in-game time on the current planet. It also provides information about the daily cycle of the planet, like when the sun goes down, which can be helpful if you want to avoid being struck by lightning on Fulgora.

The mod is inspired by [What Time Is It](https://mods.factorio.com/mod/WhatTimeIsIt), but tries a different visual style and fixes some of its issues.

## Features

- Opens a small UI in the top left corner of the screen with the current time and location.
  - Clock UI can be toggled with a per-player mod setting or with a keyboard shortcut.
- Shows the time of day on the current planet in 24-hour "HH:MM" format.
  - Days are always 24 hours a 60 minutes, but time passes differently on each planet.
- **Customizable clock precision** (per-player setting)
  - By default, the clock only updates every 10 in-game minutes to reduce visual distraction (12:10, 12:20, 12:30, ...).
  - Available options: 1 minute, 5 minutes, 10 minutes, 15 minutes, dynamic precision.
  - With "dynamic precision" the clock precision / update rate is adjusted to the day length of the current planet, so that there is roughly one update per real second. For example, Vulcanus has very short days, so the clock only updates every 20 in-game minutes, while on Nauvis the clock updates every 5 minutes.
- Shows the current planet with additional information about each phase of the day: Sunrise, day, sunset, night.
  - This is based on the `LuaSurface` properties `morning`, `dawn`, `dusk` and `evening`.
  - These times are actually the same on all Space Age planets, but they are writable properties, so technically (and realistically) they could be different. I think mods could even implement seasons using this... (Anyone wanna try? 😅)
- You can alt-click the planet button to open the planet's Factoriopedia page.
  - Regular clicks don't do anything yet - open for suggestions!
- When you are on a space platform that is orbiting a planet, the icon and time of the planet are displayed.
- Properly handles surfaces created by mods that are not planets or space platforms (like Blueprint Sandboxes).
- Indicates when the time on a surface is frozen by displaying the time in gray.

## Usage

- Install the mod. The clock will open automatically. :)
- Hover the planet button to get information about the day times on the current planet.
- Alt-click the planet button to open the planet's Factoriopedia page.

## Mod compatibility

The mod should be fully compatible with any mod that adds new planets or space locations, and display the correct icon and time.

Mods that add custom non-planet surfaces should be implicitly supported. The mod simply falls back to just showing a question mark as the location icon if it doesn't recognize the type of surface.

However, there is also some explicit support for a bunch of mods to improve the overall experience, for example by showing a fitting icon and tooltip for surfaces created by these mods:

- [Factorissimo 3](https://mods.factorio.com/mod/factorissimo-2-notnotmelon): When the player enters a factory building, the clock shows the icon and time of the actual planet that the building stands on. This feels more immersive and useful than displaying the factory floor "planet" (where the time is frozen at 12:00).
- [Blueprint Sandboxes](https://mods.factorio.com/mod/blueprint-sandboxes): Displays the mod icon with a custom tooltip as the location.
- [Drawing board](https://mods.factorio.com/mod/drawing-board): Displays the mod icon with a custom tooltip as the location.
- [Compact circuits](https://mods.factorio.com/mod/compaktcircuit): Displays the "Compact processor" entity icon with a custom tooltip as the location.

If you encounter any mod incompatibilities, or want me to add custom support for your mod, please reach out to me!

## Known issues / future ideas

- The planet/location button doesn't have any functionality besides alt-clicking for opening the planet's Factoriopedia page.
  - I couldn't figure out how to open the Factoriopedia page via code by just clicking the button. Alt-clicking works without any code, because the planet button is technically a `choose-elem-button` for space locations, which is locked to make it read-only.
  - If you have any suggestions what clicking the button could do, please tell me. ^^
- I thought about (optionally) showing the current day on the planet, but haven't implemented it so far.
  - I'm not sure what would be the best way to do this. On Nauvis (or whatever planet the player starts on) I could just use the "ticks since start of the game" to calculate the current day, but what should be shown on other planets?
  - Again, feel free to reach out with suggestions if you would like to have this feature.

## Credits

Thanks to [CaptainDapper](https://mods.factorio.com/user/CaptainDapper) for the [original mod idea](https://mods.factorio.com/mod/WhatTimeIsIt).

Also, special thanks to my wonderful girlfriend [Aurora_Bee](https://deadinsi.de/@Aurora_Bee) for the emotional support. 💜

## Support

Feel free to report bugs and mod incompatibilities, or to request new features either on the [Discussion page](https://mods.factorio.com/mod/its-about-time/discussion) or in the [GitHub issues](https://github.com/binaryDiv/factorio-its-about-time).
