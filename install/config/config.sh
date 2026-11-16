mkdir -p ~/.config
cp -R "$UBUNTU_PATH"/config/* ~/.config/

# The compositor entry point moved to Hyprland Lua; a stale copy of the old
# hyprland.conf would be loaded instead of hyprland.lua on the next reload.
rm -f ~/.config/hypr/hyprland.conf

cp "$UBUNTU_PATH"/default/bashrc ~/.bashrc
