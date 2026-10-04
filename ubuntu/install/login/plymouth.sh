#!/bin/bash
if command -v plymouth-set-default-theme >/dev/null 2>&1; then
  if [[ $(plymouth-set-default-theme) != "omarchy" ]]; then
    sudo cp -r "$UBUNTU_PATH/default/plymouth" /usr/share/plymouth/themes/omarchy/
    sudo plymouth-set-default-theme omarchy
  fi
else
  sudo cp -r "$UBUNTU_PATH/default/plymouth" /usr/share/plymouth/themes/omarchy/
  sudo sed -i 's/^Theme=.*/Theme=omarchy/' /etc/plymouth/plymouthd.conf 2>/dev/null || echo "Theme=omarchy" | sudo tee /etc/plymouth/plymouthd.conf >/dev/null
  sudo update-initramfs -u -k all
fi
