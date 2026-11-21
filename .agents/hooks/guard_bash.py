"""PreToolUse hook for Bash: block git commands that skip checks or rewrite history.

Exit code 2 blocks the call and shows stderr to the agent (Claude Code, Codex,
Gemini CLI and Copilot all treat it as a deny). Only command segments that
start with `git` are inspected, so text that merely mentions these flags is allowed.
"""

import json
import re
import shlex
import sys


SEGMENT_SEPARATORS = re.compile(r'[;&|\n]+|\$\(')
GIT_OPTIONS_WITH_VALUE = {'-C', '-c', '--git-dir', '--work-tree', '--namespace'}
PROTECTED_BRANCHES = {'main', 'master'}


def git_arguments(segment: str) -> list[str] | None:
    """Return the arguments after `git` (global options removed), or None."""
    try:
        tokens = shlex.split(segment)
    except ValueError:
        tokens = segment.split()
    while tokens and '=' in tokens[0] and not tokens[0].startswith('-'):
        tokens = tokens[1:]  # leading VAR=value assignments
    if not tokens or tokens[0] != 'git':
        return None
    args = tokens[1:]
    while args and args[0].startswith('-'):
        args = args[2:] if args[0] in GIT_OPTIONS_WITH_VALUE else args[1:]
    return args


def has_short_flag(args: list[str], flag: str) -> bool:
    return any(
        arg.startswith('-') and not arg.startswith('--') and flag in arg[1:]
        for arg in args
    )


def violation(args: list[str]) -> str | None:
    subcommand, options = (args[0], args[1:]) if args else ('', [])
    skips_hooks = '--no-verify' in options or (
        subcommand == 'commit' and has_short_flag(options, 'n')
    )
    if skips_hooks:
        return 'skipping git hooks is not allowed; fix the failing check instead'
    if subcommand == 'push':
        if '--force' in options or has_short_flag(options, 'f'):
            return 'force push can destroy history; use --force-with-lease'
        targets = {arg.rsplit(':', 1)[-1] for arg in options if not arg.startswith('-')}
        if targets & PROTECTED_BRANCHES:
            return 'never push to the default branch; open a pull request'
    return None


def main() -> int:
    command = json.load(sys.stdin).get('tool_input', {}).get('command', '')
    for segment in SEGMENT_SEPARATORS.split(command):
        args = git_arguments(segment)
        if args is not None and (reason := violation(args)):
            sys.stderr.write(f'Blocked by .agents/hooks/guard_bash.py: {reason}.\n')
            return 2
    return 0


if __name__ == '__main__':
    sys.exit(main())
