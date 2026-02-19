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
| 🐍 **Python 3.14+** | Latest stable Python with syntax auto-upgraded via `pyupgrade` |
| 📦 **Poetry** | Reproducible builds with pinned lockfile and local `.venv` |
| ⚡ **Ruff** | Blazing-fast linter and formatter — replaces `flake8`, `isort`, and `black` in one tool |
| 🔍 **MyPy** | Strict static type checking and type safety enforcement |
| 🧪 **Pytest + pytest-cov** | Parallel test suite with branch coverage and an 80% minimum coverage gate |
| 🔒 **pre-commit** | Code quality hooks sourced from the project's own virtualenv — zero version drift |
| 📐 **Commitizen** | Enforces [Conventional Commits](https://www.conventionalcommits.org) on every commit message |
| 🛡️ **pip-audit** | Scans `poetry.lock` for dependencies with known CVEs |
| 🧹 **deptry** | Detects unused, missing, and transitive dependencies in `pyproject.toml` |
| 🚀 **python-semantic-release** | Automates versioning and changelog generation from Conventional Commits |

---

## 🚀 Why this template?

- **Instant scaffold** — `make install` is all you need. No manual wiring, no hunting for config examples.
- **Reproducible builds** — Poetry lockfile + local virtualenv ensure every developer and CI run uses the exact same dependency versions.
- **Version-locked tooling** — pre-commit hooks run via `poetry run`, so the linter, formatter, and type checker in hooks always match `poetry.lock`. No drift, ever.
- **Quality gates enforced** — Ruff, MyPy, and an 80% coverage threshold block bad code before it hits the repo.
- **Conventional Commits baked in** — Commitizen validates every commit message, keeping changelogs and versioning automatable from day one.
- **Scalable project structure** — clean Python package layout (not a flat script pile) that grows with your codebase.
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
python main.py
```

---

## 🧪 Testing

```bash
make tests       # run tests
make coverage    # run tests + coverage report (fails below 80%)
```

---

## 🛠️ Development

### Makefile commands

```bash
make help                # list all commands
make install             # install dependencies
make tests               # run tests in parallel
make coverage            # run tests with coverage (fails below 80%)
make audit               # scan dependencies for known CVEs
make release             # bump version, update CHANGELOG and tag locally (no push)
make pre-commit          # run all pre-commit hooks
make setup-pre-commit    # install git hooks (commit-msg + pre-push)
make pre-commit-update   # update pre-commit hooks
make clean               # clean caches and build artifacts
```

### Pre-commit hooks

All hooks run from the project's virtualenv via `poetry run` — no separately installed binaries, no version mismatch between your editor, CI, and git hooks:

| Hook | Stage | What it does |
|------|-------|-------------|
| `pyupgrade` | pre-push | Modernizes syntax to Python 3.14+ idioms |
| `ruff` | pre-push | Lints and auto-fixes — covers flake8, isort, and more |
| `ruff-format` | pre-push | Opinionated code formatting |
| `mypy` | pre-push | Static type checking for type safety |
| `commitizen` | commit-msg | Enforces Conventional Commits spec |

```bash
make setup-pre-commit   # install hooks
```

---

## ⚙️ CI/CD

The included GitHub Actions workflow (`.github/workflows/ci.yml`) runs on every push and pull request to `main`:

| Job | Trigger | What it does |
|-----|---------|-------------|
| **Quality** | push + PR | Linting, formatting, type-check, tests, `pip-audit`, `deptry` |
| **Release** | push to `main` only | Bumps version, updates `CHANGELOG.md`, creates tag and GitHub release |

The release job only runs after **Quality** passes, and requires a `GH_TOKEN` secret (automatically available in GitHub Actions via `secrets.GITHUB_TOKEN`).

---

## 📁 Project Structure

```
python-template/
├── calculator/               # Source package
│   ├── __init__.py           # Public API exports
│   └── calc.py               # Example module
├── tests/                    # Test suite (outside the package)
│   └── test_calc.py
├── main.py                   # Entry point
├── pyproject.toml            # Project config (deps, ruff, mypy, pytest, coverage)
├── poetry.toml               # Poetry settings (virtualenv created inside project)
├── poetry.lock               # Pinned dependencies
├── .pre-commit-config.yaml   # Pre-commit hooks
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
Targets the latest stable Python for best performance and modern language features. To downgrade, edit `requires-python` and `target-version` in `pyproject.toml`.

**Can I use this as a cookiecutter alternative?**
Yes. Use the GitHub template button to scaffold a new repo instantly, or pull via Git. There's no generator step — the structure is ready to rename and adapt.

**What is `poetry.toml`?**
It pins `virtualenvs.in-project = true`, so Poetry always creates `.venv/` inside the project root. This makes the environment easy to locate for editors, type checkers, and `poetry run`.

**Why do pre-commit hooks use `poetry run` instead of remote repos?**
Remote repos pin their own tool versions independently of your project. Using `repo: local` with `poetry run` means every hook runs at the exact version in `poetry.lock` — the same binary your editor and CI use.

**How do I enable pre-commit hooks?**
Run `make setup-pre-commit`. This installs hooks for the `commit-msg` (Commitizen) and `pre-push` (Ruff, MyPy, etc.) stages.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

1. Fork the project
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'feat: add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

<div align="center">

Made with ❤️ by [Victor Predebon](https://github.com/victorpredebon)

</div>
