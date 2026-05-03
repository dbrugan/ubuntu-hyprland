#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define locations
export UBUNTU_PATH="$HOME/.local/share/ubuntu-hyprland"
export UBUNTU_INSTALL="$UBUNTU_PATH/install"
export UBUNTU_INSTALL_LOG_FILE="/var/log/ubuntu-install.log"
export PATH="$UBUNTU_PATH/bin:$PATH"

# Install
source "$UBUNTU_INSTALL/helpers/all.sh"
source "$UBUNTU_INSTALL/preflight/all.sh"
source "$UBUNTU_INSTALL/packaging/all.sh"
source "$UBUNTU_INSTALL/config/all.sh"
source "$UBUNTU_INSTALL/login/all.sh"
source "$UBUNTU_INSTALL/post-install/all.sh"
