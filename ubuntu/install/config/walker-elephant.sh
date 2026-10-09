# Ensure Walker service is started automatically on boot
mkdir -p ~/.config/autostart/
cp "$UBUNTU_PATH/default/walker/walker.desktop" ~/.config/autostart/

# And is restarted if it crashes or is killed
mkdir -p ~/.config/systemd/user/app-walker@autostart.service.d/
cp "$UBUNTU_PATH/default/walker/restart.conf" ~/.config/systemd/user/app-walker@autostart.service.d/restart.conf

# Both pacscripts' post_install tell the user to do this, and ub-restart-walker
# expects elephant.service to be enabled
if ub-cmd-present elephant; then
  elephant service enable
fi

# Link the visual theme menu config
mkdir -p ~/.config/elephant/menus
ln -snf "$UBUNTU_PATH/default/elephant/ubuntu_themes.lua" ~/.config/elephant/menus/ubuntu_themes.lua
ln -snf "$UBUNTU_PATH/default/elephant/ubuntu_background_selector.lua" ~/.config/elephant/menus/ubuntu_background_selector.lua
ln -snf "$UBUNTU_PATH/default/elephant/ubuntu_unlocks.lua" ~/.config/elephant/menus/ubuntu_unlocks.lua