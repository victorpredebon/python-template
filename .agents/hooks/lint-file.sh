#!/usr/bin/env bash
# After a file edit: run Ruff on the Python files the agent just changed. Ruff fixes what
# it can in place; what it can't goes back to the agent right after the edit, instead of
# only when the stop hook runs every gate.
set -uo pipefail
source "$(dirname "$0")/lib.sh"

# The edited paths: `file_path` (Claude Code, Gemini CLI) or `path` (Copilot), or the
# file headers of the patch Codex's apply_patch sends as `command`.
paths="$(python3 -c '
import json, re, sys

args = json.load(sys.stdin).get("tool_input") or {}
paths = [args[key] for key in ("file_path", "path") if isinstance(args.get(key), str)]
patch = args.get("command") if isinstance(args.get("command"), str) else ""
paths += re.findall(r"^\*\*\* (?:Add File|Update File|Move to): (.+)$", patch, re.MULTILINE)
print("\n".join(path.strip() for path in paths))
')"

command -v uv > /dev/null && [[ -d .venv ]] || exit 0 # the session-start hook installs it

problems=""
while IFS= read -r file; do
  [[ "${file}" == *.py && -f "${file}" ]] || continue
  # Fix first, then format: fixes such as removing an unused import can leave blank lines.
  output="$(uv run --no-sync ruff check --fix --quiet --output-format concise -- "${file}" 2> /dev/null)"
  status=$?
  uv run --no-sync ruff format --quiet -- "${file}" > /dev/null 2>&1
  if [[ ${status} -ne 0 ]]; then
    problems+="${output}"$'\n'
  fi
done <<< "${paths}"

if [[ -n "${problems}" ]]; then
  reply tool "Ruff found problems it could not fix (fix the code, never suppress the rule):
${problems}"
fi
exit 0
