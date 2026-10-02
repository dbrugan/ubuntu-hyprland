if [[ -n ${UBUNTU_ONLINE_INSTALL:-} ]]; then
  # Ubuntu ships firefox as a snap-transition package, so install it from
  # Mozilla's apt repository instead. This follows Mozilla's own instructions:
  # https://support.mozilla.org/en-US/kb/install-firefox-linux
  #
  # curl and gpg are installed by preflight/apt.sh, which runs before this.
  MOZILLA_FINGERPRINT="35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3"
  MOZILLA_KEYRING="/etc/apt/keyrings/packages.mozilla.org.asc"
  MOZILLA_SOURCES="/etc/apt/sources.list.d/mozilla.sources"
  MOZILLA_PREFERENCES="/etc/apt/preferences.d/mozilla"

  # Resolve to true only when the file exists and already matches. Keeping this
  # in a variable so both checks below read the same way.
  file_matches() {
    [[ -f $1 ]] && [[ "$(cat "$1")" == "$2" ]]
  }

  if [[ ! -f $MOZILLA_KEYRING ]]; then
    sudo install -d -m 0755 /etc/apt/keyrings
    curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg |
      sudo tee "$MOZILLA_KEYRING" >/dev/null
  fi

  # Verify the signing key before trusting it. Fail loudly rather than adding a
  # repository signed by an unexpected key.
  fingerprint=$(gpg -n -q --import --import-options import-show "$MOZILLA_KEYRING" 2>/dev/null |
    awk '/^pub/ { getline; gsub(/^ +| +$/, "") ; print; exit }')

  if [[ $fingerprint != "$MOZILLA_FINGERPRINT" ]]; then
    echo "Error: Mozilla signing key fingerprint mismatch." >&2
    echo "  expected: $MOZILLA_FINGERPRINT" >&2
    echo "  found:    ${fingerprint:-none}" >&2
    exit 1
  fi

  # Debian 13 / Ubuntu 26.04 and newer take the deb822 form.
  mozilla_sources="Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: $MOZILLA_KEYRING"

  if ! file_matches "$MOZILLA_SOURCES" "$mozilla_sources"; then
    printf '%s\n' "$mozilla_sources" | sudo tee "$MOZILLA_SOURCES" >/dev/null
  fi

  # This pin is load-bearing. Ubuntu's transitional firefox carries epoch 1,
  # which outranks Mozilla's unversioned build on raw version comparison, so
  # without it apt selects the snap wrapper instead.
  mozilla_preferences="Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000"

  if ! file_matches "$MOZILLA_PREFERENCES" "$mozilla_preferences"; then
    printf '%s\n' "$mozilla_preferences" | sudo tee "$MOZILLA_PREFERENCES" >/dev/null
  fi

  sudo apt update
fi
