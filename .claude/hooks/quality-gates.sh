#!/usr/bin/env bash
# Stop hook: before Claude ends its turn, run the fast quality gates if Python code,
# tests or dependencies changed. Exit code 2 sends the failures back to Claude, which
# keeps working until they pass (Claude Code caps consecutive blocks).
set -uo pipefail

cat > /dev/null # hook input (unused)

# In CI (e.g. the Claude review workflow) this would run PR-controlled code.
if [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 1

if ! command -v poetry > /dev/null || [[ ! -d .venv ]]; then
  echo "quality-gates hook: run 'make install' to enable the automatic checks." >&2
  exit 1 # non-blocking notice
fi

paths=(src tests pyproject.toml poetry.lock)
changed="$(git status --porcelain -- "${paths[@]}")"
if [[ -z "${changed}" ]] && git rev-parse --verify --quiet origin/main > /dev/null; then
  changed="$(git log --oneline origin/main..HEAD -- "${paths[@]}")"
fi
if [[ -z "${changed}" ]]; then
  exit 0
fi

if ! output="$(make lint typecheck tests 2>&1)"; then
  {
    echo "Quality gates failed. Fix the cause (do not weaken the check) before finishing:"
    echo "${output}" | tail -n 60
  } >&2
  exit 2
fi
exit 0
