#!/bin/bash
# Install omarchy SDDM theme
ub-refresh-sddm

# Setup SDDM login service
sudo mkdir -p /usr/local/share/wayland-sessions
sudo cp "$UBUNTU_PATH/default/wayland-sessions/omarchy.desktop" /usr/local/share/wayland-sessions/omarchy.desktop
sudo cp "$UBUNTU_PATH/default/sddm/hyprland.conf" /usr/share/sddm/hyprland.conf

sudo mkdir -p /etc/sddm.conf.d
cat <<CONF | sudo tee /etc/sddm.conf.d/10-wayland.conf >/dev/null
[General]
DisplayServer=wayland

[Wayland]
CompositorCommand=start-hyprland -- --config /usr/share/sddm/hyprland.conf
CONF

if [[ ! -f /etc/sddm.conf.d/autologin.conf ]]; then
  cat <<CONF | sudo tee /etc/sddm.conf.d/autologin.conf
[Autologin]
User=$USER
Session=omarchy

[Theme]
Current=omarchy
CONF
else
  sudo sed -i 's/^Session=hyprland-uwsm$/Session=omarchy/' /etc/sddm.conf.d/autologin.conf
fi

# Ensure SDDM session is registered with systemd
if [[ -f /etc/pam.d/sddm ]]; then
  sudo sed -i '/^@include common-session$/a\session required pam_systemd.so' /etc/pam.d/sddm
fi
if [[ -f /etc/pam.d/sddm-autologin ]]; then
  sudo sed -i '/^@include common-session$/a\session required pam_systemd.so' /etc/pam.d/sddm-autologin
fi
# Don't use chrootable here as --now will cause issues for manual installs
sudo systemctl enable sddm.service
