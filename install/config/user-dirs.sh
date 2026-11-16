mkdir -p ~/Downloads ~/Pictures ~/Videos ~/Projects ~/.config/gtk-3.0

# Written whole rather than appended so re-running the install does not
# accumulate duplicate bookmark entries.
cat >~/.config/gtk-3.0/bookmarks <<EOF
file://$HOME/Downloads Downloads
file://$HOME/Projects Projects
file://$HOME/Pictures Pictures
file://$HOME/Videos Videos
EOF