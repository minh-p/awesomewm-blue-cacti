local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local StatusCenterAttach = {
    refreshTime = 10
}

function StatusCenterAttach:createCalendarWidget()
    if self.calendar then return end
    self.calendar = require("widgets.calendar").create()
end


function StatusCenterAttach:createWibar()
    -- setup widgets
    self:createCalendarWidget()

    if not self.statusCenterWibox then
        self.statusCenterWibox = awful.wibar {
            width = 180,
            height = self.screen.geometry.height - 200,
            visible = false,
            fg = "#ffffff",
            bg = gears.color.transparent,
            border_width = 1,
            screen = self.screen,
            position = "right"
        }

        self.statusCenterWibox : setup {
            layout = wibox.layout.align.vertical,
            {
                layout = wibox.layout.fixed.vertical,
                wibox.container.margin(self.calendar, 5, 5, 10, 10),
            }
        }
    end
end


function StatusCenterAttach:handleVisibleness(invisible)
    if invisible or self.statusCenterWibox.visible then
        self.statusCenterWibox.visible = false
        return
    end

    -- set appropriate position
    local screenGeometry = self.screen.geometry
    self.statusCenterWibox.y = screenGeometry.y + 30
    self.statusCenterWibox.visible = true

    -- update calendar
    self.calendar.date = os.date("*t")
end


function StatusCenterAttach:handleSignals(mytextclock)
    mytextclock:connect_signal("button::press", function() self:handleVisibleness() end)
end


function StatusCenterAttach:attach(mytextclock, screen)
    self.screen = screen
    self:createWibar()
    -- make my text clock visible calendar when clicked
    self:handleSignals(mytextclock)
end


function StatusCenterAttach:new()
    self.__index = self
    return setmetatable({}, self)
end

return StatusCenterAttach
