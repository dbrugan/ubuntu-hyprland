source $UBUNTU_INSTALL/preflight/guard.sh
source $UBUNTU_INSTALL/preflight/begin.sh
run_logged $UBUNTU_INSTALL/preflight/show-env.sh
run_logged $UBUNTU_INSTALL/preflight/apt.sh
run_logged $UBUNTU_INSTALL/preflight/pacstall.sh
run_logged $UBUNTU_INSTALL/preflight/mozilla.sh
run_logged $UBUNTU_INSTALL/preflight/first-run-mode.sh
