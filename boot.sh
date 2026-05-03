#!/bin/bash

# Set install mode to online since boot.sh is used for curl installations
export UBUNTU_ONLINE_INSTALL=true

ansi_art='
               ██
               ██                                     ██
               ██ ████                      ███       ███████
  ██     ██    ███    ███    ██     ██   ███   ███    ██       ██     ██
  ██     ██    ██      ██    ██     ██   ██      ██   ██       ██     ██
  ██     ██    ██       ██   ██     ██   ██      ██   ██       ██     ██
  ██     ██    ██      ██    ██     ██   ██      ██   ██       ██     ██
   ███   ██    ██     ███     ███   ██   ██      ██   ███   █   ███   ██
     █████       █████          █████    ██      ██     █████     █████  '

clear
echo -e "\n$ansi_art\n"

sudo apt update && sudo apt --yes install git

if [[ -z "${UBUNTU_REPO:-}" ]]; then
  echo "Error: UBUNTU_REPO environment variable must be set."
  exit 1
fi

echo -e "\nCloning from: https://github.com/${UBUNTU_REPO}.git"
rm -rf ~/.local/share/ubuntu-hyprland/
git clone "https://github.com/${UBUNTU_REPO}.git" ~/.local/share/ubuntu-hyprland >/dev/null

echo -e "\nInstallation starting..."
source ~/.local/share/ubuntu-hyprland/install.sh
