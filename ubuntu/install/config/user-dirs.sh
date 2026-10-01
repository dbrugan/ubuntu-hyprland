mkdir -p ~/Downloads ~/Pictures ~/Videos ~/Projects ~/.config/gtk-3.0

touch ~/.config/gtk-3.0/bookmarks
for dir in Downloads Projects Pictures Videos; do
  printf 'file://%s/%s %s\n' "$HOME" "$dir" "$dir" >>~/.config/gtk-3.0/bookmarks
done