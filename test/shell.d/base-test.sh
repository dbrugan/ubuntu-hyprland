# Shared assertions for test/shell.d/*-test.sh suites.
# Source this file; do not execute it directly.

pass() {
  printf 'ok - %s\n' "$1"
}

fail() {
  printf 'not ok - %s\n' "$1" >&2
  exit 1
}

assert_output_contains() {
  local description="$1"
  local output="$2"
  local expected="$3"

  if [[ $output != *"$expected"* ]]; then
    printf 'Expected output to contain: %s\n' "$expected" >&2
    printf 'Actual output:\n%s\n' "$output" >&2
    fail "$description"
  fi

  pass "$description"
}

assert_output_not_contains() {
  local description="$1"
  local output="$2"
  local unexpected="$3"

  if [[ $output == *"$unexpected"* ]]; then
    printf 'Expected output to omit: %s\n' "$unexpected" >&2
    printf 'Actual output:\n%s\n' "$output" >&2
    fail "$description"
  fi

  pass "$description"
}
