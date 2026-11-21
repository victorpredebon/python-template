#!/usr/bin/env bash
# Stop hook: before the agent ends its turn, run the fast quality gates if Python code,
# tests or dependencies changed. Failures go back to the agent, which keeps working
# until they pass (Claude Code and Copilot cap how many times in a row).
set -uo pipefail
cat > /dev/null # hook input (unused)
source "$(dirname "$0")/lib.sh"

in_ci_review && exit 0

if ! command -v uv > /dev/null || [[ ! -d .venv ]]; then
  echo "quality-gates hook: run 'make install' to enable the automatic checks." >&2
  exit 1 # non-blocking notice
fi

paths=(src tests pyproject.toml uv.lock)
changed="$(git status --porcelain -- "${paths[@]}")"
if [[ -z "${changed}" ]] && git rev-parse --verify --quiet origin/main > /dev/null; then
  changed="$(git log --oneline origin/main..HEAD -- "${paths[@]}")"
fi
if [[ -z "${changed}" ]]; then
  exit 0
fi

if ! output="$(make lint typecheck tests 2>&1)"; then
  reply stop "Quality gates failed. Fix the cause (do not weaken the check) before finishing:
$(echo "${output}" | tail -n 60)"
fi
exit 0
