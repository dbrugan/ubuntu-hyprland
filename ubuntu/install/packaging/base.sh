# Install all base packages. The list has an apt section and a pacstall section,
# each installed by the helper for that backend.
packages_file="$UBUNTU_INSTALL/ubuntu-base.packages"

mapfile -t apt_packages < <(awk '/^# --- pacstall ---$/ { exit } !/^#/ && NF' "$packages_file")
mapfile -t pacstall_packages < <(awk '/^# --- pacstall ---$/ { section = "pacstall"; next } section == "pacstall" && !/^#/ && NF' "$packages_file")

ub-pkg-add "${apt_packages[@]}"
ub-pkg-pacstall-add "${pacstall_packages[@]}"
