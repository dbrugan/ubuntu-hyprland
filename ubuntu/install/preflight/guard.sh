abort() {
  echo -e "\e[31mInstallation requires: $1\e[0m"
  echo
  gum confirm "Proceed anyway on your own accord and without assistance?" || exit 1
}

# Must not be running as root
if (( EUID == 0 )); then
  abort "Running as root (not user)"
fi

# Must be x86 only to fully work
if [[ $(uname -m) != "x86_64" ]]; then
  abort "x86_64 CPU"
fi

# Must be Ubuntu 26.04, the release this setup targets and is tested against.
# Widening the supported set is a deliberate decision, not a routine one: it
# means re-running the package audit against each added release, since package
# names are not stable across Ubuntu releases.
supported_lts=(26.04)
os_id=""
os_version=""
if [[ -f /etc/os-release ]]; then
  # ID is unquoted in os-release but VERSION_ID is quoted, so strip both
  os_id=$(grep -m1 '^ID=' /etc/os-release | cut -d= -f2- | tr -d "\"'")
  os_version=$(grep -m1 '^VERSION_ID=' /etc/os-release | cut -d= -f2- | tr -d "\"'")
fi

if [[ $os_id != "ubuntu" ]] || [[ ! " ${supported_lts[*]} " == *" ${os_version} "* ]]; then
  abort "Supported Ubuntu LTS (currently: ${supported_lts[*]})"
fi

# Must have secure boot disabled
# bootctl ships with systemd-boot, which is absent on a Limine system, so fall
# back to reading the SecureBoot EFI variable: sysfs exposes 4 bytes of
# attributes ahead of the data byte.
secure_boot_enabled() {
  if command -v mokutil &>/dev/null; then
    [[ $(mokutil --sb-state 2>/dev/null) == "SecureBoot enabled" ]]
    return
  fi

  local efi="/sys/firmware/efi/efivars/SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c"
  [[ -f $efi ]] || return 1
  [[ $(od -An -tu1 -j4 -N1 "$efi" 2>/dev/null | tr -d ' \n') == 1 ]]
}

secure_boot_enabled && abort "Secure Boot disabled"

# Must not have Gnome or KDE already installed
if dpkg -s gnome-shell 2>/dev/null | grep -q 'Status: install ok installed' ||
   dpkg -s plasma-desktop 2>/dev/null | grep -q 'Status: install ok installed'; then
  abort "No existing desktop environment"
fi

# Must have btrfs root filesystem
[[ $(findmnt -n -o FSTYPE /) = "btrfs" ]] || abort "Btrfs root filesystem"

# Cleared all guards
echo "Guards: OK"
