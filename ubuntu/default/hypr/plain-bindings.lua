-- The reduced keybinding set that ub-remove-preinstalls installs after removing
-- the preinstalled applications. Only bindings for things a post-preinstall
-- install still has.
o.bind("SUPER + RETURN", "Terminal", 'uwsm-app -- xdg-terminal-exec --dir="$(ub-cmd-terminal-cwd)"')
o.bind("SUPER + SHIFT + RETURN", "Browser", "ub-launch-browser")
o.bind("SUPER + SHIFT + F", "File manager", "uwsm-app -- nautilus --new-window")
o.bind("SUPER + SHIFT + ALT + F", "File manager (cwd)", 'uwsm-app -- nautilus --new-window "$(ub-cmd-terminal-cwd)"')
o.bind("SUPER + SHIFT + N", "Editor", "ub-launch-editor")
o.bind("SUPER + T", "Top", "ub-launch-tui btop")
