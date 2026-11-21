import importlib.util
import io
import json
from pathlib import Path

import pytest


HOOK = Path(__file__).parents[1] / '.agents' / 'hooks' / 'guard_bash.py'
BLOCKED = 2
ALLOWED = 0

_spec = importlib.util.spec_from_file_location('guard_bash', HOOK)
assert _spec is not None
assert _spec.loader is not None
guard_bash = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(guard_bash)


def run_hook(command: str, monkeypatch: pytest.MonkeyPatch) -> int:
    payload = json.dumps({'tool_input': {'command': command}})
    monkeypatch.setattr('sys.stdin', io.StringIO(payload))
    exit_code: int = guard_bash.main()
    return exit_code


@pytest.mark.parametrize(
    'command',
    [
        'git commit -m "feat: x" --no-verify',
        'git commit -nm "x"',
        'git -c core.hooksPath=/dev/null commit -m x --no-verify',
        'git -C . push --force origin feat',
        'cd x && git push -f',
        'git commit -m "fix: handle a; b" && git push -f',
        'git push origin HEAD:main',
        'FOO=1 git push origin main',
    ],
)
def test_blocks_hook_skipping_force_and_default_branch_pushes(
    command: str, monkeypatch: pytest.MonkeyPatch
) -> None:
    assert run_hook(command, monkeypatch) == BLOCKED


@pytest.mark.parametrize(
    'command',
    [
        'git commit -am "fix: y"',
        'git push --force-with-lease origin feat',
        'git push -u origin feat/x',
        'git log -n 5',
        'echo "use git commit -n" | grep -n x',
        "cat > f <<'EOF'\nblocks `--no-verify` and `git commit -n`\nEOF",
    ],
)
def test_allows_safe_commands_and_text_mentions(
    command: str, monkeypatch: pytest.MonkeyPatch
) -> None:
    assert run_hook(command, monkeypatch) == ALLOWED
