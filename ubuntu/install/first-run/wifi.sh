if ! ping -c3 -W1 1.1.1.1 >/dev/null 2>&1; then
  ub-notification-send "    Update System" "When you have internet, click to update the system." -u critical
  ub-notification-send "󰖩    Click to Setup Wi-Fi" "Tab to navigate, Space to select, ? for help." -u critical
else
  ub-notification-send "    Update System" "Click to update the system." -u critical
fi
