# Solve common flakiness with SSH
echo "net.ipv4.tcp_mtu_probing=1" | sudo tee /etc/sysctl.d/90-ubuntu-ssh-flakiness.conf >/dev/null
sudo sysctl --system >/dev/null 2>&1