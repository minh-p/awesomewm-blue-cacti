local awful = require("awful")
local gears = require("gears")
return {
    run = function(screen)
        local function set_wallpaper(s)
            -- Wallpaper
            if beautiful.wallpaper then
                local wallpaper = beautiful.wallpaper
                -- If wallpaper is a function, call it with the screen
                if type(wallpaper) == "function" then
                    wallpaper = wallpaper(s)
                end
                gears.wallpaper.maximized(wallpaper, s, true)
            end
        end

        -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
        screen:connect_signal("property::geometry", set_wallpaper)
        set_wallpaper(screen)
    end
}
