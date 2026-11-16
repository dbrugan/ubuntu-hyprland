#!/bin/bash

set -e

# This script only hands off to install.sh. The repo is expected to already be
# cloned to ~/.local/share/ubuntu-hyprland, which is where install.sh resolves
# its own install tree from. See README.md for the full install steps.

# Directory holding this script, so the handoff works from any working directory
UBUNTU_SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Set install mode to online since boot.sh is used for curl installations
export UBUNTU_ONLINE_INSTALL=true

clear
echo
cat "$UBUNTU_SOURCE_DIR/logo.txt"
echo

echo -e "\nInstallation starting..."
source "$UBUNTU_SOURCE_DIR/install.sh"
