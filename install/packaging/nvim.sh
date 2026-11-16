# Neovim config (LazyVim) from dbrugan-lazyvim
NVIM_DIR="$HOME/.config/nvim"
TMP_DIR="$HOME/.config/nvim.tmp.$(date +%s)"

if [[ -d $NVIM_DIR ]]; then
  mv "$NVIM_DIR" "$NVIM_DIR.bak.$(date +%s)"
fi

if git clone https://github.com/dbrugan/dbrugan-lazyvim.git "$TMP_DIR"; then
  mv "$TMP_DIR" "$NVIM_DIR"
else
  rm -rf "$TMP_DIR"
  echo "Failed to clone neovim config" >&2
  exit 1
fi
