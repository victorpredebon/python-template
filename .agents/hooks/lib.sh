# Shared by the agent hooks (sourced, not run). Every agent runs the same scripts; only
# the way a hook answers differs, so it lives here:
# - Claude Code, Codex and Gemini CLI read stderr when a hook exits with code 2.
# - GitHub Copilot reads one JSON object on stdout; its config sets AGENT_HOOK_FORMAT=copilot.
# - Gemini CLI parses stdout as JSON; its config sets AGENT_HOOK_FORMAT=gemini.

# Run from the project root whatever directory the agent started the hook in.
cd "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2> /dev/null || pwd)}" || exit 0

# Inside a CI job, such as the Claude review workflow, a hook would run code from the
# pull request. Copilot's cloud agent also runs on Actions, but there it is the agent's
# own sandbox and the hooks should run.
in_ci_review() {
  [[ "${GITHUB_ACTIONS:-}" == "true" && "${AGENT_HOOK_FORMAT:-}" != "copilot" ]]
}

json_object() { # json_object KEY VALUE [KEY VALUE ...]: print a JSON object of strings
  python3 -c 'import json, sys; a = sys.argv[1:]; print(json.dumps(dict(zip(a[::2], a[1::2]))))' "$@"
}

# reply KIND MESSAGE: give MESSAGE to the agent, then exit.
#   tool    after a tool ran: the agent sees the problem and fixes it
#   stop    the agent tried to finish: it keeps working on MESSAGE instead
#   context session start: MESSAGE is added to the agent's context
reply() {
  local kind="$1" message="$2"
  case "${AGENT_HOOK_FORMAT:-}:${kind}" in
    copilot:stop) json_object decision block reason "${message}" ;;
    copilot:*) json_object additionalContext "${message}" ;;
    gemini:context) json_object systemMessage "${message}" ;;
    *:context) echo "${message}" ;;
    *)
      echo "${message}" >&2
      exit 2
      ;;
  esac
  exit 0
}
