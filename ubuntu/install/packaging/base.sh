# Install all base packages
mapfile -t packages < <(grep -v '^#' "$UBUNTU_INSTALL/ubuntu-base.packages" | grep -v '^$')
ub-pkg-add "${packages[@]}"
