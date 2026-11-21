#!/usr/bin/env bash
# Fails when a pull request adds ways to silence a quality gate (noqa, type: ignore,
# skipped tests, ...) or changes gate configuration, unless a code owner approved it
# by adding the override label. Agents must not be able to approve their own bypass,
# so the label only counts when a human code owner (not a bot) added it, and a later
# push that changes gates again revokes it (the label is removed).
#
# Env: BASE_SHA, HEAD_SHA (required); BEFORE_SHA (previous head, on new pushes);
#      REPO, PR_NUMBER, GH_TOKEN (for the label check).
set -euo pipefail

: "${BASE_SHA:?}" "${HEAD_SHA:?}"
LABEL="${OVERRIDE_LABEL:-allow-gate-change}"

# Added Python comments that silence a check. Never allowed, not even with the label:
# fix the code, or fix the rule in its own PR.
suppression_pattern='#.*(noqa|type:[[:space:]]*ignore|pyright:[[:space:]]*ignore|mypy:[[:space:]]*ignore-errors|ast-grep-ignore|pragma:[[:space:]]*no[[:space:]]*cover)'
# Added Python lines that skip tests. Sometimes legitimate (platform-specific), so a
# code owner can approve them.
code_pattern='pytest[.](mark[.](skip|skipif|xfail)|skip[(]|xfail[(]|importorskip[(])|unittest[.]skip'
# Added or removed configuration lines that tune a gate (incl. quoted rule codes)
# or grant workflows write access.
config_pattern='fail_under|ignore|strict|select|disable|stages|exclude|omit|severity|continue-on-error|threshold|min[A-Z_]|layers|forbidden|"[A-Z]+[0-9]+"|:[[:space:]]*write'
config_paths=(pyproject.toml .pre-commit-config.yaml .github/zizmor.yml .github/workflows
  .github/actions .jscpd.json sgconfig.yml rules rule-utils)

# Prints "path: line" for lines changed between two commits that match the pattern.
scan() {
  local from="$1" to="$2" pattern="$3" signs="$4"
  shift 4
  git diff --unified=0 --no-color "${from}" "${to}" -- "$@" |
    awk -v pattern="${pattern}" -v signs="${signs}" '
      /^\+\+\+ / { file = substr($0, 7); next }
      /^--- /    { next }
      index(signs, substr($0, 1, 1)) && substr($0, 2) ~ pattern { print file ": " $0 }
    '
}

# Prints every gate change between two commits.
gate_changes() {
  local from="$1" to="$2"
  scan "${from}" "${to}" "${code_pattern}" '+' '*.py'
  scan "${from}" "${to}" "${config_pattern}" '+-' "${config_paths[@]}"
  # Deleting a project rule or its tests silently drops a check, and this script
  # is the gate on all of the above.
  git diff --diff-filter=D --name-only "${from}" "${to}" -- rules rule-tests rule-utils | sed 's/^/deleted: /'
  git diff --name-only "${from}" "${to}" -- .github/scripts/check-quality-gates.sh | sed 's/^/modified: /'
}

suppressions="$(scan "${BASE_SHA}" "${HEAD_SHA}" "${suppression_pattern}" '+' '*.py')"
if [[ -n "${suppressions}" ]]; then
  echo "Suppression comments are not allowed:"
  echo "${suppressions}"
  echo "::error::This PR adds comments that silence a check. They are never allowed, not even with the '${LABEL}' label: fix the code so the check passes, or fix the rule itself in a separate PR."
  exit 1
fi

findings="$(gate_changes "${BASE_SHA}" "${HEAD_SHA}")"

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

has_label="$(gh api "repos/${REPO}/issues/${PR_NUMBER}/labels" --jq "any(.[]; .name == \"${LABEL}\")")"

# An approval covers what the code owner saw. If this push changes gates again (or
# rewrote history so we can't tell), revoke it so the new changes get reviewed.
if [[ "${has_label}" == "true" && -n "${BEFORE_SHA:-}" ]]; then
  if git cat-file -e "${BEFORE_SHA}^{commit}" 2> /dev/null; then
    new_findings="$(gate_changes "${BEFORE_SHA}" "${HEAD_SHA}")"
  else
    new_findings="history rewritten: previous head ${BEFORE_SHA} is gone"
  fi
  if [[ -n "${new_findings}" ]]; then
    echo "This push changes quality gates again:"
    echo "${new_findings}"
    if ! gh api --silent -X DELETE "repos/${REPO}/issues/${PR_NUMBER}/labels/${LABEL}"; then
      echo "::error::Could not revoke the '${LABEL}' approval (read-only token, e.g. a fork PR). A code owner must remove and re-add the label after reviewing this push."
      exit 1
    fi
    has_label=false
    echo "::warning::Removed '${LABEL}': the approval did not cover this push."
  fi
fi

# Who added the override label most recently?
labeler="$(gh api --paginate "repos/${REPO}/issues/${PR_NUMBER}/events" \
  --jq ".[] | select(.event == \"labeled\" and .label.name == \"${LABEL}\") | \"\(.actor.login) \(.actor.type)\"" | tail -n 1)"

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
