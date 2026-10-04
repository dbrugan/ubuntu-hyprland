#!/bin/bash
if command -v snapper >/dev/null 2>&1; then
  snapper -c root create-config / 2>/dev/null || true
  sudo cp "$UBUNTU_PATH/default/snapper/root" /etc/snapper/configs/root
  sudo btrfs quota disable / 2>/dev/null || true
fi
