-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Ubuntu's bootstrap keeps path setup out of this user config.
dofile((os.getenv("UBUNTU_PATH") or (os.getenv("HOME") .. "/.local/share/ubuntu-hyprland")) .. "/default/hypr/bootstrap.lua")

-- Disable all Ubuntu default bindings. Add your own in hypr/bindings.lua.
-- ubuntu_default_bindings = false

-- Load Ubuntu defaults.
require("default.hypr.ubuntu")

-- Put your personal overrides in these files. They're loaded after Ubuntu's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
