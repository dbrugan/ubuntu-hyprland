#!/bin/bash
# Ported login-stage scripts (execution order):
run_logged $UBUNTU_INSTALL/login/plymouth.sh
run_logged $UBUNTU_INSTALL/login/default-keyring.sh
run_logged $UBUNTU_INSTALL/login/sddm.sh
run_logged $UBUNTU_INSTALL/login/snapper-root.sh
