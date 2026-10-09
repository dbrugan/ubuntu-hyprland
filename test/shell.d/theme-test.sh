#!/bin/bash
# Theme/plymouth command surface stays consistent with ~/.config/ubuntu paths.
set -euo pipefail

TEST_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "$TEST_DIR/base-test.sh"

ROOT=$(cd -- "$TEST_DIR/../.." && pwd)
export PATH="$ROOT/ubuntu/bin:$PATH"

for cmd in ub-theme-set ub-theme-bg-set ub-plymouth-set ub-plymouth-set-by-theme ub-plymouth-reset; do
  [[ -x $ROOT/ubuntu/bin/$cmd ]] || fail "theme command exists and is executable: $cmd"
  pass "theme command exists and is executable: $cmd"
done

if ! "$ROOT/ubuntu/bin/ub" commands --json | jq -e 'all(.commands[]; select(.binary | test("^ub-(theme|plymouth)")) | .summary != "undocumented")' >/dev/null; then
  fail "theme/plymouth commands are documented in the dispatcher"
fi
pass "theme/plymouth commands are documented in the dispatcher"

config_paths=$(rg -o --no-filename '\.config/ubuntu/current[^"]*' "$ROOT/ubuntu/bin/ub-theme-set" "$ROOT/ubuntu/bin/ub-theme-bg-set" | sort -u)
[[ -n $config_paths ]] || fail "theme commands reference ~/.config/ubuntu/current"
pass "theme commands reference ~/.config/ubuntu/current"

if rg -qn 'mkinitcpio|limine-mkinitcpio' "$ROOT/ubuntu/bin/ub-plymouth-set" "$ROOT/ubuntu/bin/ub-plymouth-reset"; then
  fail "plymouth commands use Arch initramfs tooling instead of update-initramfs"
fi
pass "plymouth commands rebuild initramfs with update-initramfs"
