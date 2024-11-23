
# Python Template

Template for Python projects, with some development tools

## Development Tools

- pytest
- pre-commit
- black
- isort
- commitizen
- poetry
- ruff
- mypy

## Setup

This project uses Poetry, [install](https://python-poetry.org/docs/#installation)

Initialize the environment

```bash
  poetry shell
```

install dependencies

```bash
  poetry install
```

Initialize the pre commit hooks

```bash
  make pre-commit-install
```

lint

```bash
  make lint
```

tests

```bash
  make tests
  make tests-coverage
```

## Authors

- [@victorpredebon](https://github.com/victorpredebon)
