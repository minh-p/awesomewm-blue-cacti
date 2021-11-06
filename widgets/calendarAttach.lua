local wibox = require("wibox")
local gears = require("gears")

local CalendarAttach = {
    creationPropertiesChanges = {},
}

function CalendarAttach:createCalendar()
    if not self.calendar then
        self.calendar = wibox.widget {
            date = os.date("*t"),
            spacing = 2,
            week_numbers = false,
            start_sunday = true,
            widget = wibox.widget.calendar.month
        }

        -- apply property changes if there are any.
        for propName, propVal in pairs(self.creationPropertiesChanges) do
            self.calendar[propName] = propVal
        end
    end

    local function rounded_rect(cr, width, height)
        return gears.shape.rounded_rect(cr, width, height, 5)
    end


    if not self.calendarWibox then
        self.calendarWibox = wibox {
            height = 135,
            width = 150,
            visible = false,
            fg = "#ffffff",
            bg = "#1c3740",
            shape = rounded_rect,
            border_width = 1,
            screen = self.screen,
        }

        self.calendarWibox : setup {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
                self.calendar,
            }
        }
        self.calendarWibox.ontop = true
    end
end


function CalendarAttach:handleVisibleness()
    if self.calendarWibox.visible then
        self.calendarWibox.visible = false
        return
    end

    -- set appropriate position for monitor and stuff and then visible
    local screenGeometry = self.screen.geometry
    self.calendarWibox.x = screenGeometry.x + 1755
    self.calendarWibox.y = screenGeometry.y + 40
    self.calendarWibox.visible = true
end


function CalendarAttach:handleSignals(mytextclock)
    mytextclock:connect_signal("button::press", function(lx, ly) self:handleVisibleness() end)
end


function CalendarAttach:attach(mytextclock, screen)
    self.screen = screen
    self:createCalendar()
    -- make my text clock visible calendar when clicked
    self:handleSignals(mytextclock)
end


function CalendarAttach:new()
    self.__index = self
    return setmetatable({}, self)
end

return CalendarAttach
