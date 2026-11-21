#!/usr/bin/env bash
# PostToolUse hook for Edit/Write: format and lint the Python file Claude just changed.
# Ruff fixes what it can in place; what it can't goes back to Claude (exit code 2)
# right after the edit, instead of only when the Stop hook runs every gate.
set -uo pipefail

file="$(python3 -c 'import json, sys; print(json.load(sys.stdin).get("tool_input", {}).get("file_path", ""))')"
[[ "${file}" == *.py && -f "${file}" ]] || exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
command -v uv > /dev/null && [[ -d .venv ]] || exit 0 # the session-start hook installs it

# Fix first, then format: fixes such as removing an unused import can leave blank lines.
output="$(uv run --no-sync ruff check --fix --quiet --output-format concise -- "${file}" 2> /dev/null)"
status=$?
uv run --no-sync ruff format --quiet -- "${file}" > /dev/null 2>&1
if [[ ${status} -ne 0 ]]; then
  {
    echo "Ruff found problems it could not fix (fix the code, never suppress the rule):"
    echo "${output}"
  } >&2
  exit 2
fi
exit 0
