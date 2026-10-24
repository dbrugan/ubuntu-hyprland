-- Menus.
o.bind("SUPER + SPACE", "Launch apps", "ub menu summon apps")
o.bind("SUPER + CTRL + C", "Capture menu", "ub-menu capture")
o.bind("SUPER + CTRL + O", "Toggle menu", "ub-menu toggle")
o.bind("SUPER + CTRL + H", "Hardware menu", "ub-menu hardware")
o.bind("SUPER + ALT + SPACE", "Ubuntu menu", "ub-menu")
o.bind("SUPER + SHIFT + code:201", "Ubuntu menu", "ub-menu")
o.bind("SUPER + ESCAPE", "System menu", "ub-menu system")
o.bind("XF86PowerOff", "Power menu", "ub-menu system", { locked = true })
o.bind("SUPER + K", "Show key bindings", "ub-menu-keybindings")
o.bind("XF86Calculator", "Calculator", "gnome-calculator")

-- Aesthetics.
o.bind_toggle("SUPER + SHIFT + SPACE", "Toggle top bar", "bar")
o.bind("SUPER + CTRL + SPACE", "Theme background menu", "ub-menu background")
o.bind("SUPER + SHIFT + CTRL + SPACE", "Theme menu", "ub-menu theme")
o.bind("SUPER + BACKSPACE", "Toggle window transparency", "ub-hyprland-window-transparency-toggle")
o.bind("SUPER + SHIFT + BACKSPACE", "Toggle window gaps", "ub-hyprland-window-gaps-toggle")
o.bind("SUPER + CTRL + BACKSPACE", "Toggle single-window square aspect", "ub-hyprland-window-single-square-aspect-toggle")

-- Notifications.
-- xkbcommon names the comma keysym "comma"; the upper-case "COMMA" does not match.
o.bind("SUPER + comma", "Dismiss last notification", "ub-shell notifications dismissOne")
o.bind("SUPER + SHIFT + comma", "Dismiss all notifications", "ub-shell notifications dismissAll")
o.bind_toggle("SUPER + CTRL + comma", "Toggle silencing notifications", "notification-silencing")
o.bind("SUPER + ALT + comma", "Invoke last notification", "ub-shell notifications invokeLast")

-- Toggles.
o.bind_toggle("SUPER + CTRL + I", "Toggle locking on idle", "idle")
o.bind_toggle("SUPER + CTRL + N", "Toggle nightlight", "nightlight")
o.bind("SUPER + CTRL + Delete", "Toggle laptop display", "ub-hyprland-monitor-internal toggle")
o.bind("SUPER + CTRL + ALT + Delete", "Toggle laptop display mirroring", "ub-hyprland-monitor-internal-mirror toggle")
o.bind("switch:on:Lid Switch", nil, "ub-hw-external-monitors && ub-hyprland-monitor-internal off", { locked = true })
o.bind("switch:off:Lid Switch", nil, "ub-hyprland-monitor-internal on", { locked = true })

-- Captures.
o.bind("PRINT", "Screenshot", "ub-capture-screenshot")
o.bind("ALT + PRINT", "Screenrecording", "ub-menu screenrecord")
o.bind("SUPER + PRINT", "Color picker", "pkill hyprpicker || hyprpicker -a")
o.bind("SUPER + CTRL + PRINT", "Extract text (OCR) from screenshot", "ub-capture-text-extraction")

-- File sharing.
o.bind("SUPER + CTRL + S", "Share", "ub-menu share")

-- Transcoding.
o.bind("SUPER + CTRL + PERIOD", "Transcode", "ub-transcode")

-- Reminders.
o.bind("SUPER + CTRL + R", "Set reminder", "ub-menu reminder-set")
o.bind("SUPER + CTRL + ALT + R", "Show reminders", "ub-reminder show")
o.bind("SUPER + SHIFT + CTRL + R", "Clear reminders", "ub-reminder clear")

-- Waybar-less information.
o.bind("SUPER + CTRL + ALT + T", "Show time", 'ub-notification-send "" "    $(date +"%A %H:%M  ·  %d %B %Y  ·  Week %V")"')
o.bind("SUPER + CTRL + ALT + B", "Show battery remaining", 'ub-notification-send "" "    $(ub-battery-status)"')
o.bind("SUPER + CTRL + ALT + W", "Show weather", 'ub-notification-send "" "$(ub-weather-status)"')

-- Control panels.
o.bind("SUPER + CTRL + A", "Audio controls", "ub-launch-audio")
o.bind("SUPER + CTRL + B", "Bluetooth controls", "ub-launch-bluetooth")
o.bind("SUPER + CTRL + W", "Wifi controls", "ub-launch-wifi")
o.bind("SUPER + CTRL + T", "Activity", { tui = "btop" })

-- Dictation bindings are omitted: voxtype is not ported, so these would invoke
-- a command that does not exist. The emoji and clipboard-manager bindings
-- arrive with the shell's deferred emojis and clipboard plugins.

-- Zoom.
o.bind("SUPER + CTRL + Z", "Zoom in", function()
  local zoom = hl.get_config("cursor.zoom_factor") or 1
  hl.config({ cursor = { zoom_factor = zoom + 1 } })
end)

o.bind("SUPER + CTRL + ALT + Z", "Reset zoom", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end)

-- Lock system.
o.bind("SUPER + CTRL + L", "Lock system", "ub-system-lock")
