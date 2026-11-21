#!/usr/bin/env bash
# Session start: install the locked dependencies, so `make` and the other hooks work from
# the first prompt, also in fresh cloud sessions. Never blocks the session.
set -uo pipefail
cat > /dev/null # hook input (unused)
source "$(dirname "$0")/lib.sh"

in_ci_review && exit 0

if ! command -v uv > /dev/null; then
  reply context "uv is not installed, so dependencies are missing: install uv (https://docs.astral.sh/uv/), then run 'make install'."
fi
if ! output="$(uv sync --locked --quiet 2>&1)"; then
  reply context "'uv sync --locked' failed, so the environment may be incomplete:
$(echo "${output}" | tail -n 20)"
fi
exit 0
