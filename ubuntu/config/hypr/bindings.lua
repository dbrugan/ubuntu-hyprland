-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   ub menu keybindings

-- Application bindings.
o.bind("SUPER + RETURN", "Terminal", "uwsm-app -- xdg-terminal-exec --dir=\"$(ub-cmd-terminal-cwd)\"")
o.bind("SUPER + ALT + RETURN", "Tmux", 'uwsm-app -- xdg-terminal-exec --dir="$(ub-cmd-terminal-cwd)" bash -c "tmux attach || tmux new -s Work"')
o.bind("SUPER + SHIFT + RETURN", "Browser", "ub-launch-browser")
o.bind("SUPER + SHIFT + F", "File manager", "uwsm-app -- nautilus --new-window")
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", 'uwsm-app -- nautilus --new-window "$(ub-cmd-terminal-cwd)"')
o.bind("SUPER + SHIFT + B", "Browser", "ub-launch-browser")
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", "ub-launch-browser --private")
o.bind("SUPER + SHIFT + M", "Music", "ub-launch-or-focus spotify")
o.bind("SUPER + SHIFT + ALT + M", "Music TUI", "ub-launch-or-focus-tui cliamp")
o.bind("SUPER + SHIFT + N", "Editor", "ub-launch-editor")
o.bind("SUPER + SHIFT + D", "Docker", "ub-launch-tui lazydocker")
o.bind("SUPER + SHIFT + G", "Signal", 'ub-launch-or-focus "^signal$" "uwsm-app -- signal-desktop"')
o.bind("SUPER + SHIFT + O", "Obsidian", 'ub-launch-or-focus "^obsidian$" "uwsm-app -- obsidian"')
o.bind("SUPER + SHIFT + W", "Typora", "uwsm-app -- typora --enable-wayland-ime")
o.bind("SUPER + SHIFT + SLASH", "Passwords", "uwsm-app -- 1password")

-- Web app bindings are omitted: this setup intentionally ships no webapps,
-- and ub-launch-webapp / ub-launch-or-focus-webapp are not ported.

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Ubuntu root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Ubuntu menu", "ub-menu")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "ub-capture-screenshot") -- Print Screen Button
-- o.bind("SUPER + H", nil, "voxtype record toggle") -- Dictation Button
-- Emoji and clipboard bindings arrive with the shell's deferred emojis and
-- clipboard plugins.
