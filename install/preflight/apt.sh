if [[ -n ${UBUNTU_ONLINE_INSTALL:-} ]]; then
  sudo apt update
  sudo apt upgrade -y
  # curl and gnupg are tooling the later preflight stages call: pacstall.sh
  # fetches pacstall's bootstrap over the network, and mozilla.sh imports and
  # verifies the Mozilla signing key. Both are Priority: optional, so a
  # debootstrap base does not have them.
  ub-pkg-add build-essential software-properties-common curl gnupg

  # Third-party repositories for packages Ubuntu does not ship
  sudo add-apt-repository -y ppa:jdxcode/mise
  sudo add-apt-repository -y ppa:cppiber/hyprland

  sudo apt update
fi