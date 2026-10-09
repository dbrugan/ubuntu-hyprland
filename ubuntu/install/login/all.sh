run_logged $UBUNTU_INSTALL/login/plymouth.sh
run_logged $UBUNTU_INSTALL/login/default-keyring.sh
run_logged $UBUNTU_INSTALL/login/limine-snapper.sh
run_logged $UBUNTU_INSTALL/login/sddm.sh

# Intentionally not ported from upstream: hibernation.sh calls upstream's
# omarchy-hibernation-setup, which creates a btrfs /swap subvolume and swapfile
# to resume from. The target spec is no swap, zram only, so there is nothing for
# it to resume. See the Known WIP Gaps section in AGENTS.md.
#
# limine-snapper.sh is ported, but rewritten: it replaces upstream's mkinitcpio,
# pacman hook, and libalpm plumbing with initramfs-tools, ukify, and pacstall.