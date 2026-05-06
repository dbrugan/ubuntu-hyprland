if [[ -n ${UBUNTU_ONLINE_INSTALL:-} ]]; then
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y build-essential
fi
