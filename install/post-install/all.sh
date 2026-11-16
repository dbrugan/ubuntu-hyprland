# End of install: render the logo, report how long it took, offer a reboot.
#
# Sourced rather than run_logged, because run_logged redirects stdout and
# stderr into the log file, which would hide the logo, the duration, and
# the reboot prompt.
source $UBUNTU_INSTALL/post-install/finished.sh
