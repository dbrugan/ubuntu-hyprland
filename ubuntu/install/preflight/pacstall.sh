if [[ -n ${UBUNTU_ONLINE_INSTALL:-} ]]; then
  # pacstall is not in the Ubuntu archive; it ships its own installer
  if ub-cmd-missing pacstall; then
    sudo bash -c "$(curl -fsSL https://pacstall.dev/q/install)"
  fi

  # Our pacscripts (walker, elephant, and friends) live in our own pacstall repo.
  # The bootstrap above resets pacstallrepo, so add ours after it runs.
  if ! grep -q "dbrugan-pacstall-programs" /usr/share/pacstall/repo/pacstallrepo; then
    sudo pacstall -A https://github.com/dbrugan/dbrugan-pacstall-programs/tree/master/packages
  fi
fi
