#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define locations
export UBUNTU_PATH="$HOME/.local/share/ubuntu-hyprland"
export UBUNTU_INSTALL="$UBUNTU_PATH/install"
export UBUNTU_INSTALL_LOG_FILE="/var/log/ubuntu-install.log"
export PATH="$UBUNTU_PATH/bin:$PATH"

# Refuse to run unless the install tree is present at the canonical location.
# This check sits ahead of helpers/all.sh so a missing tree fails as a plain
# message instead of tripping the error trap that file arms.
if [[ ! -f $UBUNTU_INSTALL/helpers/all.sh ]]; then
  echo "Error: No install tree found at $UBUNTU_PATH"
  echo
  echo "Clone the repo to that path, then run boot.sh from inside it:"
  echo "  git clone <repo-url> $UBUNTU_PATH"
  echo "  cd $UBUNTU_PATH && ./boot.sh"
  exit 1
fi

# Install
source "$UBUNTU_INSTALL/helpers/all.sh"
source "$UBUNTU_INSTALL/preflight/all.sh"
source "$UBUNTU_INSTALL/packaging/all.sh"
source "$UBUNTU_INSTALL/config/all.sh"
source "$UBUNTU_INSTALL/login/all.sh"
source "$UBUNTU_INSTALL/post-install/all.sh"
