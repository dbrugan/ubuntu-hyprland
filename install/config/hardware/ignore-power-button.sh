# Disable shutting system down on power button to bind it to power menu afterwards
# A logind.conf.d drop-in takes precedence over logind.conf and survives
# package upgrades, unlike editing logind.conf in place.
sudo install -d /etc/systemd/logind.conf.d
echo "HandlePowerKey=ignore" | sudo tee /etc/systemd/logind.conf.d/99-ubuntu-power-button.conf >/dev/null

# Reload logind rather than restarting it, which can disturb active sessions.
sudo systemctl kill -s HUP systemd-logind