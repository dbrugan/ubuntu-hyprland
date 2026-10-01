# Set identification from install inputs
if [[ -n ${UBUNTU_USER_NAME//[[:space:]]/} ]]; then
  git config --global user.name "$UBUNTU_USER_NAME"
fi

if [[ -n ${UBUNTU_USER_EMAIL//[[:space:]]/} ]]; then
  git config --global user.email "$UBUNTU_USER_EMAIL"
fi