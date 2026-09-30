# Neovim config (LazyVim) from dbrugan-lazyvim
NVIM_DIR="$HOME/.config/nvim"

if [[ -d $NVIM_DIR ]]; then
  mv "$NVIM_DIR" "$NVIM_DIR.bak.$(date +%s)"
fi

git clone https://github.com/dbrugan/dbrugan-lazyvim.git "$NVIM_DIR"
