-- Default Hyprland bindings.
local paths = require("default.hypr.paths")
local require_all = require("default.hypr.require_all")

require_all.files(paths.ubuntu_path .. "/default/hypr/bindings", "default.hypr.bindings")
