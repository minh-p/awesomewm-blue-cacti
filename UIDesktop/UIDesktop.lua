-- Purpose: awesomewm desktopUI - layouts, statusbar
local awful = require("awful")

require("UIDesktop.wibar")
require("UIDesktop.titlebar")

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
