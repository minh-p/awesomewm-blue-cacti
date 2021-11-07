local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local StatusCenterAttach = {
    creationPropertiesChanges = {},
}

function StatusCenterAttach:createCalendarWidget()
    if self.calendar then return end
    self.calendar = require("widgets.calendar").create()
end


function StatusCenterAttach:createWibar()
    -- setup widgets
    self:createCalendarWidget()

    local function rounded_rect(cr, width, height)
        return gears.shape.rounded_rect(cr, width, height, 10)
    end
    if not self.statusCenterWibox then
        self.statusCenterWibox = awful.wibar {
            width = 180,
            visible = false,
            fg = "#ffffff",
            bg = gears.color.transparent,
            shape = rounded_rect,
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
        self.statusCenterWibox.ontop = true
    end
end


function StatusCenterAttach:handleVisibleness(invisible)
    if invisible or self.statusCenterWibox.visible then
        self.statusCenterWibox.visible = false
        return
    end

    -- set appropriate position for monitor and stuff and then visible
    local screenGeometry = self.screen.geometry
    self.statusCenterWibox.y = screenGeometry.y + 30
    self.statusCenterWibox.visible = true
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
