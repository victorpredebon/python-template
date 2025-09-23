# Python Template

![Python Version](https://img.shields.io/badge/python-3.13+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
[![Linting: Ruff](https://img.shields.io/badge/linting-ruff-yellow)](https://github.com/astral-sh/ruff)
[![Formatting: Ruff](https://img.shields.io/badge/formatting-ruff-black)](https://github.com/astral-sh/ruff)
[![Type Checking: MyPy](https://img.shields.io/badge/type%20checking-mypy-blue)](https://github.com/python/mypy)
![GitHub Issues](https://img.shields.io/github/issues/victorpredebon/python-template)
![Last Commit](https://img.shields.io/github/last-commit/victorpredebon/python-template)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://makeapullrequest.com)
[![GitHub Stars](https://img.shields.io/github/stars/victorpredebon/python-template?style=social)](https://github.com/victorpredebon/python-template/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/victorpredebon/python-template?style=social)](https://github.com/victorpredebon/python-template/fork)

A modern, opinionated Python project template for Python 3.13+, pre-configured with Poetry, Ruff, MyPy, Pytest, Coverage, and pre-commit hooks. Use it to bootstrap new repositories with consistent tooling, clean structure, and CI-ready quality gates.

## Table of Contents

- [Features](#features)
- [Why this template](#why-this-template)
- [Quick Start](#quick-start)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Usage](#usage)
- [Testing](#testing)
- [Development](#development)
- [Project Structure](#project-structure)
- [Star History](#star-history)
- [FAQ](#faq)
- [License](#license)
- [Author](#author)
- [Contributing](#contributing)

## Features

- Configured for Python 3.13+
- Dependency management with Poetry
- Code formatting and linting with Ruff
- Type checking with MyPy
- Automated testing with Pytest
- Pre-commit hooks for code quality assurance
- Organized project structure ready to scale

## Why this template

- Strong defaults for modern Python (3.13) and type safety.
- One-command setup via Makefile and Poetry.
- Fast, strict linting with Ruff and static checks with MyPy.
- Testing and coverage pre-wired with Pytest and pytest-cov.
- Pre-commit hooks to enforce quality before code lands.
- Minimal, scalable structure you can adapt to any app or library.

### Use this template

There are a few ways to start a new repository from this template:

1. Click “Use this template” on GitHub (if available) or fork the repository.
2. Or create a new repo and pull from this one:

```bash
git init my-new-project && cd my-new-project
git remote add template https://github.com/victorpredebon/python-template.git
git pull template main
git remote remove template
git branch -M main
git commit --allow-empty -m "chore: bootstrap from python-template"
```

## Quick Start

### Prerequisites

- Python 3.13 or higher
- Poetry (dependency manager)

### Installation

1. Clone this repository:

```bash
git clone https://github.com/victorpredebon/python-template.git
cd python-template
```

2. Install dependencies:

```bash
make install
```

### Usage

Activate the virtual environment:

```bash
poetry shell
```

Run the example:

```bash
python -m src.main
```

## Testing

Run tests with:

```bash
make tests
```

For coverage report:

```bash
make coverage
```

## Development

### Useful Commands

The project includes a Makefile with useful commands:

```bash
make help           # Display help message
make install        # Install dependencies
make tests          # Run tests
make coverage       # Run tests with coverage
make pre-commit     # Run pre-commit on all files
make setup-pre-commit # Setup pre-commit hooks
make pre-commit-update # Update pre-commit hooks
make clean          # Clean build artifacts and caches
```

### Pre-commit Hooks

The project uses pre-commit hooks to ensure code quality before each commit:

```bash
make setup-pre-commit  # Install hooks
```

## Project Structure

```
python-template/
├── src/             # Source code
│   ├── main.py      # Entry point
│   └── calc.py      # Example modules
├── pyproject.toml   # Project configuration
├── poetry.lock      # Pinned dependencies
├── .pre-commit-config.yaml  # Pre-commit configuration
└── Makefile         # Utility commands
```

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=victorpredebon/python-template&type=Timeline)](https://star-history.com/#victorpredebon/python-template&Timeline)

## FAQ

- How do I use this without Poetry?
  - You can install dependencies with pip, but you will need to adapt commands. Example: `pip install -r requirements.txt` (not provided by default). Poetry is recommended for reproducibility.
- Why Python 3.13?
  - Targets the latest Python features and performance. You can lower the version by editing `requires-python` and `target-version` in `pyproject.toml`.
- How do I enable pre-commit hooks?
  - Run `make setup-pre-commit`. This installs `pre-commit` hooks for `commit-msg` and `pre-push`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

- **Victor Predebon** - [GitHub](https://github.com/victorpredebon)

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
