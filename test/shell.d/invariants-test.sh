#!/bin/bash
# Repo-wide invariants for ubuntu/bin: helper usage and completed renames.
set -euo pipefail

TEST_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "$TEST_DIR/base-test.sh"

ROOT=$(cd -- "$TEST_DIR/../.." && pwd)

if rg -n --no-heading '(^|[^_-])command -v' "$ROOT/ubuntu/bin" | rg -v 'ub-cmd-(present|missing)|command -v ub( |$)|#'; then
  fail "bin/ uses raw command -v instead of ub-cmd-present/ub-cmd-missing"
fi
pass "bin/ uses command-presence helpers instead of raw command -v"

if rg -n --no-heading '(^|[^a-z-])notify-send' "$ROOT/ubuntu/bin" | rg -v 'ub-notification-send|#'; then
  fail "bin/ calls notify-send directly instead of ub-notification-send"
fi
pass "bin/ notifies via ub-notification-send instead of bare notify-send"

# The jetbrains.conf upstream PR link is provenance, not a project reference.
leftovers=$(rg -iln 'omarchy|OMARCHY_PATH|org\.omarchy|\.config/omarchy' "$ROOT/ubuntu/bin" "$ROOT/ubuntu/default" "$ROOT/ubuntu/config" | rg -v 'apps/jetbrains.conf' || true)
if [[ -n $leftovers ]]; then
  printf 'Leftover omarchy references:\n%s\n' "$leftovers" >&2
  fail "no leftover omarchy paths, env vars, or app IDs in bin/default/config"
fi
pass "no leftover omarchy references in bin/default/config"
