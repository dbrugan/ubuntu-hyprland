ICON_DIR="$HOME/.local/share/applications/icons"

ub-tui-install "Disk Usage" "bash -c 'dust -r; read -n 1 -s'" float "$ICON_DIR/Disk Usage.png"
ub-tui-install "Docker" "lazydocker" tile "$ICON_DIR/Docker.png"
