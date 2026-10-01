# Set default XCompose that is triggered with CapsLock
tee ~/.XCompose >/dev/null <<EOF
# Run ub-restart-xcompose to apply changes

# Include fast emoji access
include "%H/.local/share/ubuntu-hyprland/default/xcompose"

# Identification
<Multi_key> <space> <n> : "$UBUNTU_USER_NAME"
<Multi_key> <space> <e> : "$UBUNTU_USER_EMAIL"
EOF