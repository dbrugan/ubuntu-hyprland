# Copy over the keyboard layout set during install to Hyprland
conf="/etc/default/keyboard"
[[ -f "$conf" ]] || conf="/etc/vconsole.conf"
hyprconf="$HOME/.config/hypr/input.conf"

if [[ ! -f "$hyprconf" ]]; then
  echo "Skipping: $hyprconf not found"
elif ! grep -qE '^[[:space:]]*kb_options[[:space:]]*=' "$hyprconf"; then
  echo "Skipping: no kb_options anchor in $hyprconf"
else
  layout=$(sed -n 's/^XKBLAYOUT="\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' "$conf")
  variant=$(sed -n 's/^XKBVARIANT="\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' "$conf")

  # Replace an existing key so repeated installs stay idempotent, and only
  # insert when absent. The anchor is the first kb_options line.
  set_kb() {
    local key="$1" value="$2"
    if grep -qE "^[[:space:]]*${key}[[:space:]]*=" "$hyprconf"; then
      sed -i -E "s|^([[:space:]]*${key}[[:space:]]*=[[:space:]]*).*$|\1${value}|" "$hyprconf"
    else
      sed -i -E "/^[[:space:]]*kb_options[[:space:]]*=/i\\  ${key} = ${value}" "$hyprconf"
    fi
  }

  # XKBVARIANT is often empty; skip it so we never write a bare "kb_variant =".
  if [[ -n "$layout" ]]; then
    set_kb kb_layout "$layout"
  fi

  if [[ -n "$variant" ]]; then
    set_kb kb_variant "$variant"
  fi
fi