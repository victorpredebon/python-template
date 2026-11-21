#!/usr/bin/env bash
# SessionStart hook: install the locked dependencies, so `make` and the other hooks
# work from the first prompt, also in fresh cloud sessions (Claude Code on the web).
# What it prints is added to Claude's context; it never blocks the session.
set -uo pipefail

cat > /dev/null # hook input (unused)

# In CI (e.g. the Claude review workflow) this would install PR-controlled packages.
if [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

if ! command -v uv > /dev/null; then
  echo "uv is not installed, so dependencies are missing: install uv (https://docs.astral.sh/uv/), then run 'make install'."
  exit 0
fi

if ! output="$(uv sync --locked --quiet 2>&1)"; then
  echo "'uv sync --locked' failed, so the environment may be incomplete:"
  echo "${output}" | tail -n 20
fi
exit 0
