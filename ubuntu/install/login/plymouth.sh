# Install the Omarchy plymouth boot splash as the default theme.
#
# The theme is removed before copying rather than copied over the top:
# `cp -r src dest/` makes dest a copy of src the first time, but nests
# src/ inside dest/ on every later run.
if [[ $(plymouth-set-default-theme) != "omarchy" ]]; then
  sudo rm -rf /usr/share/plymouth/themes/omarchy
  sudo cp -r "$UBUNTU_PATH/default/plymouth" /usr/share/plymouth/themes/omarchy
  sudo plymouth-set-default-theme omarchy
fi