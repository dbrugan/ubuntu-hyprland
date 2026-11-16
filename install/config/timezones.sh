# Let the user change the timezone without a password prompt.
#
# Upstream also allowlists tzupdate, which is an Ansible tool absent on Ubuntu,
# where systemd handles the clock instead.
echo "%sudo ALL=(root) NOPASSWD: /usr/bin/timedatectl" | sudo tee /etc/sudoers.d/ubuntu-tzupdate >/dev/null
sudo chmod 0440 /etc/sudoers.d/ubuntu-tzupdate