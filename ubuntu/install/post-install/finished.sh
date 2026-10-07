stop_install_log

echo_in_style() {
  echo "$1" | tte --canvas-width 0 --anchor-text c --frame-rate 640 print
}

clear
echo
tte -i "$UBUNTU_PATH/logo.txt" --canvas-width 0 --anchor-text c --frame-rate 920 laseretch
echo

# Display installation time if available.
# helpers/logging.sh records the duration as "Installation: Xm Ys"; it used to
# be "Total:", which never matched and so the duration never displayed.
if [[ -f $UBUNTU_INSTALL_LOG_FILE ]] && grep -q "Installation:" "$UBUNTU_INSTALL_LOG_FILE" 2>/dev/null; then
  echo
  TOTAL_TIME=$(tail -n 20 "$UBUNTU_INSTALL_LOG_FILE" | grep "^Installation:" | sed 's/^Installation:[[:space:]]*//')
  if [[ -n $TOTAL_TIME ]]; then
    echo_in_style "Installed in $TOTAL_TIME"
  fi
else
  echo_in_style "Finished installing"
fi

# Nothing in this repo creates this file, but the install bootstrap may, so
# leave the cleanup in place.
if sudo test -f /etc/sudoers.d/99-ubuntu-installer; then
  sudo rm -f /etc/sudoers.d/99-ubuntu-installer &>/dev/null
fi

# Exit gracefully if user chooses not to reboot
if gum confirm --padding "0 0 0 $((PADDING_LEFT + 32))" --show-help=false --default --affirmative "Reboot Now" --negative "" ""; then
  # Clear screen to hide any shutdown messages
  clear

  if [[ -n ${UBUNTU_CHROOT_INSTALL:-} ]]; then
    touch /var/tmp/ubuntu-install-completed
    exit 0
  else
    sudo reboot 2>/dev/null
  fi
fi