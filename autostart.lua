local awful = require("awful")

local autostarts = {
    compositor = "picom --experimental-backends"
}

awful.spawn.with_shell(autostarts.compositor)
