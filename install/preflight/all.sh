source $UBUNTU_INSTALL/preflight/guard.sh
source $UBUNTU_INSTALL/preflight/begin.sh
run_logged $UBUNTU_INSTALL/preflight/show-env.sh
run_logged $UBUNTU_INSTALL/preflight/apt.sh
run_logged $UBUNTU_INSTALL/preflight/migrations.sh
run_logged $UBUNTU_INSTALL/preflight/first-run-mode.sh
