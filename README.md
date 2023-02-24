
# Python Template

Template for Python projects, with some development tools

## Development Tools

- pytest
- pre-commit
- pylint
- black
- isort
- commitizen

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
  poetry run pre-commit install --hook-type commit-msg --hook-type pre-push
```

## Authors

- [@victorpredebon](https://github.com/victorpredebon)
