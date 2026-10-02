# Ubuntu's neovim package ships no desktop entry, so supply our own before
# refreshing the database the xdg-mime calls below rely on.
mkdir -p ~/.local/share/applications
cp "$UBUNTU_PATH/default/nvim/nvim.desktop" ~/.local/share/applications/

ub-refresh-applications
update-desktop-database ~/.local/share/applications

# Open directories in file manager
xdg-mime default org.gnome.Nautilus.desktop inode/directory

# Open all images with gthumb
xdg-mime default org.gnome.gThumb.desktop image/png
xdg-mime default org.gnome.gThumb.desktop image/jpeg
xdg-mime default org.gnome.gThumb.desktop image/gif
xdg-mime default org.gnome.gThumb.desktop image/webp
xdg-mime default org.gnome.gThumb.desktop image/bmp
xdg-mime default org.gnome.gThumb.desktop image/tiff

# Open PDFs with GNOME Papers
xdg-mime default org.gnome.Papers.desktop application/pdf

# Use Firefox as the default browser. Chromium is not installed on Ubuntu by
# default and is not part of this setup's package list.
xdg-settings set default-web-browser firefox.desktop
xdg-mime default firefox.desktop x-scheme-handler/http
xdg-mime default firefox.desktop x-scheme-handler/https

# Open video files with mpv
xdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/x-msvideo
xdg-mime default mpv.desktop video/x-matroska
xdg-mime default mpv.desktop video/x-flv
xdg-mime default mpv.desktop video/x-ms-wmv
xdg-mime default mpv.desktop video/mpeg
xdg-mime default mpv.desktop video/ogg
xdg-mime default mpv.desktop video/webm
xdg-mime default mpv.desktop video/quicktime
xdg-mime default mpv.desktop video/3gpp
xdg-mime default mpv.desktop video/3gpp2
xdg-mime default mpv.desktop video/x-ms-asf
xdg-mime default mpv.desktop video/x-ogm+ogg
xdg-mime default mpv.desktop video/x-theora+ogg
xdg-mime default mpv.desktop application/ogg

# Open text files with nvim
xdg-mime default nvim.desktop text/plain
xdg-mime default nvim.desktop text/english
xdg-mime default nvim.desktop text/x-makefile
xdg-mime default nvim.desktop text/x-c++hdr
xdg-mime default nvim.desktop text/x-c++src
xdg-mime default nvim.desktop text/x-chdr
xdg-mime default nvim.desktop text/x-csrc
xdg-mime default nvim.desktop text/x-java
xdg-mime default nvim.desktop text/x-moc
xdg-mime default nvim.desktop text/x-pascal
xdg-mime default nvim.desktop text/x-tcl
xdg-mime default nvim.desktop text/x-tex
xdg-mime default nvim.desktop application/x-shellscript
xdg-mime default nvim.desktop text/x-c
xdg-mime default nvim.desktop text/x-c++
xdg-mime default nvim.desktop application/xml
xdg-mime default nvim.desktop text/xml

# Use Thunderbird for mailto: links. It installs as a snap on Ubuntu, which
# suffixes its desktop file name, so resolve it rather than assuming one.
thunderbird_desktop=$(find /var/lib/snapd/desktop/applications /usr/share/applications \
  -maxdepth 1 -name 'thunderbird*.desktop' 2>/dev/null | head -n1)

if [[ -n $thunderbird_desktop ]]; then
  xdg-mime default "$(basename "$thunderbird_desktop")" x-scheme-handler/mailto
else
  echo "Thunderbird not found; leaving the mailto handler unchanged."
fi