# Give the user 10 instead of 3 tries to fat finger their password before lockout.
echo "Defaults passwd_tries=10" | sudo tee /etc/sudoers.d/passwd-tries >/dev/null
sudo chmod 0440 /etc/sudoers.d/passwd-tries

# Upstream also sets deny = 10 in /etc/security/faillock.conf. That file ships
# entirely commented out on Ubuntu and pam_faillock is not wired into
# /etc/pam.d, so the setting would have no effect. See AGENTS.md.