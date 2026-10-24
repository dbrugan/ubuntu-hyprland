-- Keep only your personal input overrides here. Uncommented settings below
-- replace Ubuntu's defaults.

-- Keyboard layout and options.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
-- hl.config({
--   input = {
--     -- Use multiple keyboard layouts and switch between them with Left Alt + Right Alt.
--     kb_layout = "us,dk,eu",
--     kb_options = "compose:caps,grp:alts_toggle",
--     kb_variant = "intl",
--     repeat_rate = 40,
--     repeat_delay = 250,
--     numlock_by_default = true,
--     sensitivity = 0.35,
--     accel_profile = "flat",
--
--     touchpad = {
--       natural_scroll = true,
--       clickfinger_behavior = true,
--       scroll_factor = 0.4,
--       disable_while_typing = false,
--       drag_3fg = 1,
--     },
--   },
-- })

-- App-specific touchpad scroll speeds.
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Enable touchpad gestures for changing workspaces.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Enable touchpad gestures for moving focus (helpful on scrolling layout).
-- hl.gesture({ fingers = 3, direction = "left", action = "workspace" })
