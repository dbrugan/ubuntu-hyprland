-- Permanent toggle flags and disabled input devices from the state directory.
local paths = require("default.hypr.paths")
local require_all = require("default.hypr.require_all")

-- Hardcoded to ~/.local/state to match ub-hyprland-toggle, which always writes
-- there regardless of XDG_STATE_HOME.
local toggles_dir = paths.home .. "/.local/state/ubuntu/toggles/hypr"
package.path = toggles_dir .. "/?.lua;" .. package.path

require_all.files(toggles_dir, nil, { reload = true })

local disabled_input_device = require("default.hypr.disabled-input-device")
disabled_input_device("touchpad")
disabled_input_device("touchscreen")
