if [[ -n ${UBUNTU_ONLINE_INSTALL:-} ]]; then
  # Add Docker's official apt repository following
  # https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
  DOCKER_FINGERPRINT="9DC858229FC7DD38854AE2D88D81803C0EBFCD88"
  DOCKER_KEYRING="/etc/apt/keyrings/docker.asc"
  DOCKER_SOURCES="/etc/apt/sources.list.d/docker.sources"

  file_matches() {
    [[ -f $1 ]] && [[ "$(cat "$1")" == "$2" ]]
  }

  if [[ ! -f $DOCKER_KEYRING ]]; then
    sudo install -d -m 0755 /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
      sudo tee "$DOCKER_KEYRING" >/dev/null
  fi

  fingerprint=$(gpg -n -q --import --import-options import-show "$DOCKER_KEYRING" 2>/dev/null |
    awk '/^pub/ { getline; gsub(/^ +| +$/, "") ; print; exit }')

  if [[ $fingerprint != "$DOCKER_FINGERPRINT" ]]; then
    echo "Error: Docker signing key fingerprint mismatch." >&2
    echo "  expected: $DOCKER_FINGERPRINT" >&2
    echo "  found:    ${fingerprint:-none}" >&2
    exit 1
  fi

  codename=$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
  arch=$(dpkg --print-architecture)

  docker_sources="Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $codename
Components: stable
Architectures: $arch
Signed-By: $DOCKER_KEYRING"

  if ! file_matches "$DOCKER_SOURCES" "$docker_sources"; then
    printf '%s\n' "$docker_sources" | sudo tee "$DOCKER_SOURCES" >/dev/null
  fi

  sudo apt update
fi
