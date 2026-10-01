if [[ -n ${UBUNTU_ONLINE_INSTALL:-} ]]; then
  sudo apt update
  sudo apt upgrade -y
  ub-pkg-add build-essential software-properties-common

  # Third-party repositories for packages Ubuntu does not ship
  sudo add-apt-repository -y ppa:jdxcode/mise
  sudo add-apt-repository -y ppa:cppiber/hyprland

  sudo apt update
fi