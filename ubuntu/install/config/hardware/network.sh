# Ensure the iwd service will be started
sudo systemctl enable iwd.service

# Prevent systemd-networkd-wait-online timeout on boot. This setup uses
# NetworkManager rather than systemd-networkd, so the unit is not needed.
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl mask systemd-networkd-wait-online.service
