# Not yet ported from Omarchy. Port these leaf scripts, then list them here in
# execution order:
#
#   finished.sh    - stop the log tail, render the logo, offer the reboot
#   allow-reboot.sh
#
# Omarchy also runs a post-install/pacman.sh here; it has no Ubuntu equivalent
# because package refresh already happens in preflight/apt.sh.
#
# TRAP when porting finished.sh: Omarchy branches on `grep -q "Total:"` to
# decide whether to print the install duration. logging.sh dropped that line
# along with the archinstall timings it summed, and now writes
# "Installation: Xm Ys" instead. Grep for "Installation:" in finished.sh, not
# "Total:", or the duration silently never displays.
#
# Until then install.sh falls through to the EXIT trap, which stops the log
# output and restores the cursor.
