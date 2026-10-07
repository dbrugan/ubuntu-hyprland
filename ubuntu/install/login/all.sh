run_logged $UBUNTU_INSTALL/login/plymouth.sh
run_logged $UBUNTU_INSTALL/login/default-keyring.sh
run_logged $UBUNTU_INSTALL/login/sddm.sh

# Intentionally not ported from upstream, both arch-only:
#   hibernation.sh     calls omarchy-hibernation-setup, and this setup has no
#                      swap to resume from (target spec is no swap, zram only)
#   limine-snapper.sh  built on mkinitcpio, pacman transaction hooks, and
#                      default/limine assets this repo does not carry.
# See the Known WIP Gaps section in AGENTS.md.