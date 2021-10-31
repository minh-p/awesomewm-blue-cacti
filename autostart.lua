local awful = require("awful")

local autostarts = {
    compositor = "picom"
}

awful.spawn.with_shell(autostarts.compositor)
