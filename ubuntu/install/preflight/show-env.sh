# Show installation environment variables
gum log --level info "Installation Environment:"

env | grep -E "^(UBUNTU_CHROOT_INSTALL|UBUNTU_ONLINE_INSTALL|UBUNTU_USER_NAME|UBUNTU_USER_EMAIL|USER|HOME|UBUNTU_REPO|UBUNTU_REF|UBUNTU_PATH)=" | sort | while IFS= read -r var; do
  gum log --level info "  $var"
done
