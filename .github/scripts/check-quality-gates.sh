#!/usr/bin/env bash
# Fails when a pull request adds ways to silence a quality gate (noqa, type: ignore,
# skipped tests, ...) or changes gate configuration, unless a code owner approved it
# by adding the override label. Agents must not be able to approve their own bypass,
# so the label only counts when a human code owner (not a bot) added it.
#
# Env: BASE_SHA, HEAD_SHA (required); REPO, PR_NUMBER, GH_TOKEN (for the label check).
set -euo pipefail

: "${BASE_SHA:?}" "${HEAD_SHA:?}"
LABEL="${OVERRIDE_LABEL:-allow-gate-change}"

# Added Python lines that silence a check.
code_pattern='#[[:space:]]*(noqa|type:[[:space:]]*ignore|pyright:[[:space:]]*ignore)|pragma:[[:space:]]*no[[:space:]]*cover|pytest[.](mark[.](skip|skipif|xfail)|skip[(]|xfail[(]|importorskip[(])|unittest[.]skip'
# Added or removed configuration lines that tune a gate (incl. quoted rule codes).
config_pattern='fail_under|ignore|strict|select|disable|stages|exclude|omit|severity|continue-on-error|threshold|min[A-Z_]|layers|forbidden|"[A-Z]+[0-9]+"'

# Prints "path: line" for diff lines whose content matches the pattern.
scan() {
  local pattern="$1" signs="$2"
  shift 2
  git diff --unified=0 --no-color "${BASE_SHA}" "${HEAD_SHA}" -- "$@" |
    awk -v pattern="${pattern}" -v signs="${signs}" '
      /^\+\+\+ / { file = substr($0, 7); next }
      /^--- /    { next }
      index(signs, substr($0, 1, 1)) && substr($0, 2) ~ pattern { print file ": " $0 }
    '
}

findings="$(
  scan "${code_pattern}" '+' '*.py'
  scan "${config_pattern}" '+-' pyproject.toml .pre-commit-config.yaml .github/zizmor.yml .github/workflows .github/actions .jscpd.json sgconfig.yml rules
  # Deleting a project rule or its tests silently drops a check.
  git diff --diff-filter=D --name-only "${BASE_SHA}" "${HEAD_SHA}" -- rules rule-tests | sed 's/^/deleted: /'
)"

if [[ -z "${findings}" ]]; then
  echo "No quality-gate bypasses or gate configuration changes."
  exit 0
fi

echo "Changes that bypass or reconfigure quality gates:"
echo "${findings}"

if [[ -z "${PR_NUMBER:-}" ]]; then
  echo "::error::Quality-gate changes found (no pull request context to check for approval)."
  exit 1
fi

# Who added the override label most recently, and is it still on the PR?
labeler="$(gh api --paginate "repos/${REPO}/issues/${PR_NUMBER}/events" \
  --jq ".[] | select(.event == \"labeled\" and .label.name == \"${LABEL}\") | \"\(.actor.login) \(.actor.type)\"" | tail -n 1)"
has_label="$(gh api "repos/${REPO}/issues/${PR_NUMBER}/labels" --jq "any(.[]; .name == \"${LABEL}\")")"

# Code owners come from the base branch, so the PR cannot add new approvers.
# Without a CODEOWNERS file there, the repository owner is the only approver.
owners="$(git show "${BASE_SHA}:.github/CODEOWNERS" 2> /dev/null |
  awk '$1 == "*" { for (i = 2; i <= NF; i++) { sub(/^@/, "", $i); print $i } }' || true)"
owners="${owners:-${REPO%%/*}}"
login="${labeler%% *}"
type="${labeler##* }"

if [[ "${has_label}" == "true" && "${type}" == "User" ]] && grep -qxF "${login}" <<< "${owners}"; then
  echo "Approved: '${LABEL}' was added by code owner ${login}."
  exit 0
fi

echo "::error::This PR changes quality gates. A code owner must review the lines above and add the '${LABEL}' label to approve (labels added by bots do not count)."
exit 1
