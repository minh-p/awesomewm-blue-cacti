-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

require("globals")
require("awful").layout.layouts = require("UIDesktop.layouts")
require("bindings").run()
require("UIDesktop.UIDesktop")
require("rules")
require("autostart")
