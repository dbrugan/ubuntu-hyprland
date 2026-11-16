# Ubuntu 26.04 already resolves through the systemd-resolved stub, so this only
# matters when /etc/resolv.conf points somewhere else (a resolvconf-managed file,
# for example). Symlinking unconditionally would fight that setup.
if [[ ! -L /etc/resolv.conf ]] || [[ $(readlink -f /etc/resolv.conf) != "/run/systemd/resolve/stub-resolv.conf" ]]; then
  echo "Symlink resolved stub-resolv to /etc/resolv.conf"
  sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
fi