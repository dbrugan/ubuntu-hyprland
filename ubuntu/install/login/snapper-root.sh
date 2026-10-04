#!/bin/bash
if command -v snapper >/dev/null 2>&1; then
  if ! sudo snapper list-configs 2>/dev/null | grep -q "root"; then
    sudo snapper -c root create-config /
  fi
  sudo cp "$UBUNTU_PATH/default/snapper/root" /etc/snapper/configs/root
  sudo btrfs quota disable / 2>/dev/null || true
fi
