UBUNTU_MIGRATIONS_STATE_PATH=~/.local/state/ubuntu-hyprland/migrations
mkdir -p $UBUNTU_MIGRATIONS_STATE_PATH

for file in ~/.local/share/ubuntu-hyprland/migrations/*.sh; do
  touch "$UBUNTU_MIGRATIONS_STATE_PATH/$(basename "$file")"
done
