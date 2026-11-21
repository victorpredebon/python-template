<div align="center">

# 🐍 Python Template

**A modern, opinionated Python boilerplate — batteries included.**

Scaffold production-ready Python projects in seconds. Clone, run `make install`, and start shipping — linting, formatting, type checking, testing, and commit conventions already wired up.

[![Python Version](https://img.shields.io/badge/python-3.14+-blue.svg)](https://python.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Linting: Ruff](https://img.shields.io/badge/linting-ruff-yellow)](https://github.com/astral-sh/ruff)
[![Formatting: Ruff](https://img.shields.io/badge/formatting-ruff-black)](https://github.com/astral-sh/ruff)
[![Type Checking: MyPy](https://img.shields.io/badge/type%20checking-mypy-blue)](https://github.com/python/mypy)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://makeapullrequest.com)
[![GitHub Stars](https://img.shields.io/github/stars/victorpredebon/python-template?style=social)](https://github.com/victorpredebon/python-template/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/victorpredebon/python-template?style=social)](https://github.com/victorpredebon/python-template/fork)

</div>

---

## ✨ Features

| Tool | Purpose |
|------|---------|
| 🐍 **Python 3.14+** | Latest stable Python; Ruff's `UP` rules keep syntax modern |
| 📦 **Poetry** | Reproducible builds with pinned lockfile, local `.venv` and PEP 735 dependency groups |
| ⚡ **Ruff** | Blazing-fast linter and formatter — replaces `flake8`, `isort`, and `black` in one tool |
| 🔍 **MyPy** | Strict static type checking and type safety enforcement |
| 🧪 **Pytest + pytest-cov** | Parallel test suite with branch coverage and an 80% minimum coverage gate |
| 🔒 **pre-commit** | Code quality hooks sourced from the project's own virtualenv — zero version drift |
| 📐 **Commitizen** | Enforces [Conventional Commits](https://www.conventionalcommits.org) on every commit message |
| 🛡️ **pip-audit** | Scans `poetry.lock` for dependencies with known CVEs |
| 🧹 **deptry** | Detects unused, missing, and transitive dependencies in `pyproject.toml` |
| 🚀 **python-semantic-release** | Automates versioning and changelog generation from Conventional Commits (optional `release` group, installed only where it runs) |
| 🔐 **Hardened CI/CD** | Actions pinned by SHA, least-privilege tokens, zizmor + actionlint + CodeQL on the workflows, OpenSSF Scorecard, dependency review, Dependabot cooldown |
| 📦 **Signed releases** | Wheel + sdist built in an unprivileged job, smoke-tested, with CycloneDX SBOM, checksums and SLSA build provenance attached to every GitHub release |
| 🤖 **AI-agent ready** | `AGENTS.md` (read by Claude Code, Codex, Copilot, Cursor, ...) documents commands, conventions and hard rules; CI enforces everything an agent might skip locally |
| 🏛️ **Deterministic design checks** | import-linter architecture contracts, vulture (dead code), jscpd (duplication), diff-cover (100% on changed lines) and 16 generic ast-grep rules (tests, error handling, logging, types, data structures) |
| 🧬 **Hypothesis + mutmut** | Property-based tests for edge cases, and mutation testing that proves tests notice when code is wrong (coverage alone doesn't) |
| 🛂 **Gate-bypass detection** | New `noqa`, `type: ignore`, skipped tests or gate config changes need a code owner's `allow-gate-change` label |
| 🧑‍⚖️ **Independent AI review** | Optional Claude reviewer (read-only, comments only) focused on bugs, unneeded code and weak tests |
| 🪝 **Claude Code hooks** | `.claude/settings.json` runs the gates before an agent finishes and blocks skipping hooks / force pushes |

---

## 🚀 Why this template?

- **Instant scaffold** — `make install` is all you need. No manual wiring, no hunting for config examples.
- **Reproducible builds** — Poetry lockfile + local virtualenv ensure every developer and CI run uses the exact same dependency versions.
- **Version-locked tooling** — pre-commit hooks run via `poetry run`, so the linter, formatter, and type checker in hooks always match `poetry.lock`. No drift, ever.
- **Quality gates enforced** — Ruff, MyPy, and an 80% coverage threshold block bad code before it hits the repo.
- **Conventional Commits baked in** — Commitizen validates every commit message, keeping changelogs and versioning automatable from day one.
- **Scalable project structure** — installable `src/` layout with a console entry point and `py.typed`, ready to grow or publish.
- **Zero legacy config** — no `.flake8`, no `setup.cfg`, no `tox.ini`. Everything lives in `pyproject.toml`.

---

## ⚡ Quick Start

### Prerequisites

- Python 3.14+
- [Poetry](https://python-poetry.org/docs/#installation)

### Use this template

**Option 1 — GitHub template repository:** Click **"Use this template"** at the top of the page to create a new repo with this scaffold instantly.

**Option 2 — via Git:**

```bash
git init my-new-project && cd my-new-project
git remote add template https://github.com/victorpredebon/python-template.git
git pull template main
git remote remove template
git commit --allow-empty -m "chore: bootstrap from python-template"
```

### Installation

```bash
make install
```

### Run

```bash
make run                      # same as: poetry run calculator
poetry run python -m calculator
```

### Make it yours (rename checklist)

After creating your repository from the template, replace the example names:

1. **Package** — rename `src/calculator/` to your package name and update its imports in `src/` and `tests/`.
2. **`pyproject.toml`** — `name`, `description`, `authors`, `[project.scripts]` (command name and `module:function`), `packages` under `[tool.poetry]` and `source_pkgs` under `[tool.coverage.run]`.
3. **Version history** — reset `version` to `0.1.0` (or `1.0.0`) and clear `CHANGELOG.md`.
4. **Ownership** — `LICENSE` holder, `[project.urls]` in `pyproject.toml`, `.github/CODEOWNERS`, the links in `SECURITY.md` and `.github/ISSUE_TEMPLATE/config.yml`, and this README (badges, star history, author).
5. **Security model** — delete or rewrite `SECURITY_MODEL.md` for your project.
6. Run `poetry lock && make install && make check`.

Search for leftovers with `git grep -n -i -e calculator -e python-template -e predebon`.

---

## 🧪 Testing

```bash
make tests       # run tests in parallel
make coverage    # run tests + coverage report (fails below the threshold in pyproject.toml, 80%)
```

---

## 🛠️ Development

### Makefile commands

```bash
make help                # list all commands
make install             # install dependencies
make run                 # run the application
make lint                # lint and check formatting (no changes)
make format              # auto-fix lint issues and format code
make typecheck           # run mypy
make tests               # run tests in parallel
make coverage            # run tests with coverage (fails below 80%)
make audit               # scan dependencies for known CVEs
make deps                # check for unused/missing/transitive dependencies
make check               # every quality gate, same as CI
make diff-cover          # every changed line must be covered (after make coverage)
make mutation            # mutation testing (fails if any mutant survives)
make build               # build sdist + wheel into dist/ and validate them
make release             # bump version, update CHANGELOG and tag locally (no push)
make pre-commit          # run all pre-commit hooks
make setup-pre-commit    # install git hooks (commit-msg + pre-push)
make pre-commit-update   # update pre-commit hooks
make clean               # clean caches and build artifacts
```

### Pre-commit hooks

The Python tools run from the project's virtualenv via `poetry run` — no separately installed binaries, no version mismatch between your editor, CI, and git hooks. Hook stages are declared in `.pre-commit-config.yaml` itself (`default_install_hook_types`), so `make setup-pre-commit` and a plain `pre-commit install` behave the same:

| Hook | Stage | What it does |
|------|-------|-------------|
| `pre-commit-hooks` | pre-push | Whitespace, EOF, JSON/YAML/TOML validity, merge conflicts, large files, private keys, test file naming |
| `ruff` | pre-push | Lints and auto-fixes — covers flake8, isort, pyupgrade, bandit and more |
| `ruff-format` | pre-push | Opinionated code formatting |
| `mypy` | pre-push | Static type checking of the whole project (`src/` and `tests/`) |
| `import-linter` | pre-push | Architecture contracts in `pyproject.toml` (layers, forbidden imports) |
| `vulture` | pre-push | Dead code: functions, classes and attributes nothing uses |
| `ast-grep` | pre-push | Project patterns in `rules/` (+ `ast-grep test` for `rule-tests/`) |
| `jscpd` | pre-push | Duplicated code, including copy-paste within one file |
| `actionlint` | pre-push | Validates GitHub Actions workflow syntax and expressions |
| `zizmor` | pre-push | Security audit of workflows (injection, permissions, unpinned actions, cache poisoning) |
| `commitizen` | commit-msg | Enforces Conventional Commits spec |

```bash
make setup-pre-commit   # install hooks
```

---

## ⚙️ CI/CD

Six workflows, all with a read-only token by default (`permissions: {}`), every third-party Action pinned by commit SHA and kept current by Dependabot (with a 7-day cooldown).

### `ci.yml` — quality gates, packaging and release

Runs on pull requests, pushes to `main`, the merge queue, weekly (to catch new CVEs) and on demand.

| Job | When | What it does |
|-----|------|--------------|
| **Lint & type-check** | always | pre-commit: Ruff, mypy, actionlint, zizmor, file checks |
| **Test** | always | pytest on Linux, Windows and macOS; coverage gate; on PRs, 100% coverage of changed lines (diff-cover); JUnit/coverage reports as artifacts and in the job summary |
| **Dependency audit** | always | `pip-audit` (blocking) and `deptry` |
| **Dependency review** | PRs | Blocks PRs that add dependencies with known vulnerabilities (moderate+) |
| **Build package** | always | Plans the next version, builds sdist + wheel, `poetry check --strict`, `twine check --strict`, smoke-tests the wheel in a clean venv, generates a CycloneDX SBOM and `SHA256SUMS.txt` |
| **CI OK** | always | Single aggregated status — make it the only required check in your branch ruleset |
| **Release** | push to `main` with releasable commits | Verifies the artifacts, signs SLSA build provenance, creates the `vX.Y.Z` tag and GitHub release, and uploads wheel, sdist, SBOM and checksums |

How a release happens:

1. A PR is squash-merged into `main` with a Conventional Commit title (`feat:` → minor, `fix:`/`perf:` → patch, `!` → major; `docs:`/`chore:`/`ci:` → no release).
2. **Build package** asks python-semantic-release for the next version, stamps it into the package and builds it **without any write permission or cache** (so a poisoned cache or a compromised build step cannot touch the repository).
3. **Release** runs in the `release` environment (add required reviewers there to gate releases), re-checks the version and checksums, attests the artifacts and publishes the tag and release.

Verify a downloaded artifact came from this repository's workflow:

```bash
gh attestation verify python_template-X.Y.Z-py3-none-any.whl --repo victorpredebon/python-template
```

Since `main` is protected (changes only via pull request), releases run with `--no-commit`: only the tag is pushed, so `project.version` in `pyproject.toml` and `CHANGELOG.md` are not updated in the repository. The git tag (`vX.Y.Z`) is the source of truth; the built packages carry the released version.

### `pr-policy.yml` — rules for every pull request

| Job | What it does |
|-----|--------------|
| **Conventional commits** | Validates the PR title (the squash-merge commit) and every commit with Commitizen |
| **Quality-gate changes** | Fails if the PR adds `# noqa`, `# type: ignore`, `pragma: no cover`, skipped/xfail tests, or changes gate configuration (coverage threshold, Ruff/mypy rules, hook stages, workflow severities), unless a **human code owner** added the `allow-gate-change` label. Labels added by bots don't count, and code owners are read from the base branch, so an agent can't approve its own bypass. The approval covers what was reviewed: a later push that changes gates again (or rewrites history) removes the label automatically. Changes to the checker script and new `write` permissions in workflows count as gate changes too. |

It runs separately from `ci.yml` so editing the title or adding the label re-checks in seconds.

### `mutation.yml` — do the tests actually test?

[mutmut](https://github.com/boxed/mutmut) makes small changes to the code (flip a condition, change a string, drop an argument) and runs the tests. If they still pass, that behavior is untested even if coverage says 100%. Runs on PRs that touch code or tests, weekly and on demand; fails if any mutant survives.

### `claude-review.yml` — independent AI review (opt-in)

A separate Claude session with read-only tools reviews each PR and only comments. It skips style (the linters own that) and focuses on bugs, unneeded code, weak tests and `AGENTS.md` violations. Enable it by adding the `ANTHROPIC_API_KEY` secret (or running `/install-github-app` in Claude Code) and the repository variable `CLAUDE_REVIEW_ENABLED=true`.

### Deterministic code-quality checks

Rules an AI agent can be *asked* to follow are enforced by tools instead, so they hold even when the instructions are ignored:

| Concern | Tool | Configured in |
|---------|------|---------------|
| Architecture: `cli` depends on `calc`, never the reverse; `calc` has no I/O, logging or process control | import-linter | `[tool.importlinter]` in `pyproject.toml` |
| Dead code | vulture | `[tool.vulture]` |
| Copy-paste (also within one file) | jscpd | `.jscpd.json` |
| New code without tests | diff-cover (100% of changed lines) | `[tool.diff_cover]` |
| Python best practices Ruff lacks | ast-grep | `rules/` + `rule-tests/` + `rule-utils/` |

ast-grep rules (generic Python practices that Ruff doesn't cover). They find their context from the code, never from file paths: a test is a `test_*` function, the entry point is a `main` function or the `if __name__ == '__main__':` block (shared in `rule-utils/`). Each rule has valid and invalid examples checked by `ast-grep test`.

| Area | Rule | Why |
|------|------|-----|
| Tests | `test-must-assert` | A test that only runs code passes even when the result is wrong |
| Tests | `no-weak-test-assertions` | `is not None` / `isinstance` / `len(x) > 0` pass for almost any wrong result |
| Tests | `mock-requires-spec` | Mocks without `autospec`/`spec` accept calls the real object would reject ([unittest.mock docs](https://docs.python.org/3/library/unittest.mock.html#autospeccing)) |
| Tests | `no-sleep-in-tests` | Sleeps make tests slow and flaky |
| Errors | `no-swallowed-exceptions` | "Errors should never pass silently" ([PEP 20](https://peps.python.org/pep-0020/)); only the entry point may log and stop |
| Errors | `exit-only-in-main` | Code below the entry point raises; only `main` exits the process |
| Completeness | `no-stub-implementations` | `pass` / `...` / `NotImplementedError` bodies outside `@abstractmethod`, `@overload` and `Protocol` |
| Logging | `logger-uses-module-name` | `getLogger(__name__)` ([logging HOWTO](https://docs.python.org/3/howto/logging.html)) |
| Logging | `logging-config-only-in-main` | Libraries must not configure logging |
| Types | `no-untyped-dict-in-signatures` | `dict[str, Any]` in signatures → `TypedDict` / `dataclass` |
| Time | `no-wall-clock-durations` | Durations with `time.monotonic()` / `perf_counter()`, not `time.time()` |
| Data structures | `use-deque-for-queues` | `pop(0)` / `insert(0, x)` on a list are O(n); `deque` is O(1) |
| Data structures | `use-counter` | `collections.Counter` instead of manual get-and-increment |
| Data structures | `use-defaultdict` | `defaultdict` / `setdefault` instead of initializing missing keys by hand |
| Data structures | `no-large-tuple-returns` | 4+ returned values → `NamedTuple` / `dataclass` (*Effective Python*) |
| Data structures | `no-unordered-dedupe` | `list(set(x))` loses order → `list(dict.fromkeys(x))` or `sorted(set(x))` |

Ruff also has the preview rule `PLR6201` enabled on its own (`explicit-preview-rules`): use a `set` literal for membership tests. Data-structure checks Ruff already covers stay with Ruff (e.g. `namedtuple` → `typing.NamedTuple`, `sorted(x)[0]` → `min(x)`).

Changing these configurations, or deleting a rule or its tests, is a gate change: the PR policy requires the `allow-gate-change` label from a code owner.

### `codeql.yml` — static analysis

CodeQL with the `security-extended` suite for the Python code **and for the workflows themselves** (script injection, excessive permissions). Results appear under *Security → Code scanning*.

### `scorecard.yml` — supply-chain posture

[OpenSSF Scorecard](https://scorecard.dev) grades the repository's security practices (pinning, branch protection, token permissions, ...) weekly and on changes to branch protection.

### Recommended repository settings

The workflows can't enforce these; configure them once in *Settings*:

- **Rulesets → `main`:** require a pull request, require the **CI OK**, **Conventional commits** and **Quality-gate changes** status checks, require review from Code Owners, block force pushes, allow only squash merges (optionally enable the merge queue).
- **Environments → `release`:** restrict to the `main` branch; add required reviewers if releases need a human approval.
- **Code security:** enable Dependabot alerts and security updates, secret scanning with push protection, and private vulnerability reporting.

---

## 📁 Project Structure

```
python-template/
├── src/
│   └── calculator/           # Source package (installable, src layout)
│       ├── __init__.py       # Public API exports
│       ├── __main__.py       # `python -m calculator`
│       ├── calc.py           # Example module
│       ├── cli.py            # Entry point (`calculator` command)
│       └── py.typed          # PEP 561 marker: ships type hints
├── tests/                    # Test suite (outside the package)
│   ├── test_calc.py
│   └── test_cli.py
├── .github/
│   ├── actions/setup-poetry/ # Shared CI setup (composite action)
│   ├── workflows/
│   │   ├── ci.yml            # Quality gates, packaging and release
│   │   ├── pr-policy.yml     # PR title/commits and gate-bypass checks
│   │   ├── mutation.yml      # Mutation testing
│   │   ├── claude-review.yml # Optional independent AI review
│   │   ├── codeql.yml        # CodeQL for Python and workflows
│   │   └── scorecard.yml     # OpenSSF Scorecard
│   ├── scripts/              # check-quality-gates.sh
│   ├── zizmor.yml            # Workflow security audit config
│   ├── ISSUE_TEMPLATE/       # Bug report / feature request forms
│   ├── CODEOWNERS
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── dependabot.yml
├── pyproject.toml            # Project config (deps, ruff, mypy, pytest, coverage)
├── poetry.toml               # Poetry settings (virtualenv created inside project)
├── poetry.lock               # Pinned dependencies
├── .pre-commit-config.yaml   # Pre-commit hooks
├── rules/ + rule-tests/      # ast-grep rules and their tests (sgconfig.yml)
├── rule-utils/               # Shared ast-grep contexts: in a test, in the entry point
├── .jscpd.json               # Duplicated-code detection
├── .claude/                  # Claude Code settings and hooks (guard + quality gates)
├── AGENTS.md                 # Instructions for AI coding agents (CLAUDE.md imports it)
├── SECURITY.md               # How to report vulnerabilities
└── Makefile                  # Dev commands
```

---

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=victorpredebon/python-template&type=Timeline)](https://star-history.com/#victorpredebon/python-template&Timeline)

---

## ❓ FAQ

**How do I use this without Poetry?**
Install dependencies with pip and adapt commands manually. Poetry is strongly recommended for reproducible builds and lockfile management.

**Why Python 3.14?**
Targets the latest stable Python for best performance and modern language features. To downgrade, edit `.python-version`, plus `requires-python` and `target-version` in `pyproject.toml`.

**Can I use this as a cookiecutter alternative?**
Yes. Use the GitHub template button to scaffold a new repo instantly, or pull via Git. There's no generator step — the structure is ready to rename and adapt.

**What is `poetry.toml`?**
It pins `virtualenvs.in-project = true`, so Poetry always creates `.venv/` inside the project root. This makes the environment easy to locate for editors, type checkers, and `poetry run`.

**Why do pre-commit hooks use `poetry run` instead of remote repos?**
Remote repos pin their own tool versions independently of your project. Using `repo: local` with `poetry run` means every hook runs at the exact version in `poetry.lock` — the same binary your editor and CI use.

**How do I enable pre-commit hooks?**
Run `make setup-pre-commit`. This installs hooks for the `commit-msg` (Commitizen) and `pre-push` (Ruff, MyPy, etc.) stages.

**Why Commitizen *and* python-semantic-release?**
They have separate jobs: Commitizen only validates commit messages locally (`commit-msg` hook); python-semantic-release owns versioning, tags and the changelog in CI.

**How do AI coding agents fit in?**
`AGENTS.md` is the shared instruction file most agents read automatically (`CLAUDE.md` just imports it). It lists the commands, conventions and things an agent must never do (weaken gates, touch workflows as a side effect, pin Actions by tag). Nothing relies on the agent obeying, though: every rule that matters is enforced by CI, CODEOWNERS and the branch ruleset, and the PR template asks authors to disclose AI assistance.

In Claude Code, `.claude/settings.json` adds local guardrails: a Stop hook runs lint, mypy and tests whenever the agent tries to finish with changed code (failures go back to the agent); a PreToolUse hook blocks git commands that skip hooks, force pushes and pushes to `main`; editing `.github/`, `.claude/` and `AGENTS.md` asks for confirmation; and `.env`/key files can't be read. Personal overrides go in `.claude/settings.local.json` (git-ignored).

**Does it publish to PyPI?**
No, packages are attached to GitHub releases. To publish to PyPI, add a job after **Release** that downloads the `dist` artifact and runs `pypa/gh-action-pypi-publish` with [Trusted Publishing](https://docs.pypi.org/trusted-publishers/) (OIDC, no API token).

**Why isn't this a Cookiecutter/Copier template?**
So the template repository itself stays a real, runnable project whose CI tests everything you get. Follow the rename checklist in [Make it yours](#make-it-yours-rename-checklist) instead.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

1. Fork the project
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Run `make check`, then commit your changes: `git commit -m 'feat: add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

<div align="center">

Made with ❤️ by [Victor Predebon](https://github.com/victorpredebon)

</div>
