-- Volume, brightness, keyboard backlight, and touchpad controls.
o.bind("XF86AudioRaiseVolume", "Volume up", "ub-audio-output-volume raise", { locked = true, repeating = true })
o.bind("XF86AudioLowerVolume", "Volume down", "ub-audio-output-volume lower", { locked = true, repeating = true })
o.bind("XF86AudioMute", "Mute", "ub-audio-output-volume mute-toggle", { locked = true })
o.bind("XF86AudioMicMute", "Mute microphone", "ub-audio-input-mute", { locked = true })
o.bind("XF86MonBrightnessUp", "Brightness up", "ub-brightness-display +5%", { locked = true, repeating = true })
o.bind("XF86MonBrightnessDown", "Brightness down", "ub-brightness-display 5%-", { locked = true, repeating = true })
o.bind("SHIFT + XF86MonBrightnessUp", "Brightness maximum", "ub-brightness-display 100%", { locked = true, repeating = true })
o.bind("SHIFT + XF86MonBrightnessDown", "Brightness minimum", "ub-brightness-display 1%", { locked = true, repeating = true })
o.bind("XF86KbdBrightnessUp", "Keyboard brightness up", "ub-brightness-keyboard up", { locked = true, repeating = true })
o.bind("XF86KbdBrightnessDown", "Keyboard brightness down", "ub-brightness-keyboard down", { locked = true, repeating = true })
o.bind("XF86KbdLightOnOff", "Keyboard backlight cycle", "ub-brightness-keyboard cycle", { locked = true })
o.bind_toggle("XF86TouchpadToggle", "Toggle touchpad", "touchpad", { locked = true })
o.bind("XF86TouchpadOn", "Enable touchpad", "ub-toggle-touchpad on", { locked = true })
o.bind("XF86TouchpadOff", "Disable touchpad", "ub-toggle-touchpad off", { locked = true })

-- Precise 1% multimedia adjustments with Alt modifier.
o.bind("ALT + XF86AudioRaiseVolume", "Volume up precise", "ub-audio-output-volume +1", { locked = true, repeating = true })
o.bind("ALT + XF86AudioLowerVolume", "Volume down precise", "ub-audio-output-volume -1", { locked = true, repeating = true })
o.bind("ALT + XF86MonBrightnessUp", "Brightness up precise", "ub-brightness-display +1%", { locked = true, repeating = true })
o.bind("ALT + XF86MonBrightnessDown", "Brightness down precise", "ub-brightness-display 1%-", { locked = true, repeating = true })

-- Player control goes through the shell's media service, which also raises the
-- OSD when the player state changes.
o.bind("XF86AudioNext", "Next track", "ub-shell media next", { locked = true })
o.bind("XF86AudioPause", "Pause", "ub-shell media playPause", { locked = true })
o.bind("XF86AudioPlay", "Play", "ub-shell media playPause", { locked = true })
o.bind("XF86AudioPrev", "Previous track", "ub-shell media previous", { locked = true })

-- Switch audio output with Super + Mute.
o.bind("SUPER + XF86AudioMute", "Switch audio output", "ub-audio-output-switch", { locked = true })
