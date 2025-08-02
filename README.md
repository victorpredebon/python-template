# Python Template

![Python Version](https://img.shields.io/badge/python-3.13+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
[![Linting: Ruff](https://img.shields.io/badge/linting-ruff-yellow)](https://github.com/astral-sh/ruff)
[![Formatting: Ruff](https://img.shields.io/badge/formatting-ruff-black)](https://github.com/astral-sh/ruff)
[![Type Checking: MyPy](https://img.shields.io/badge/type%20checking-mypy-blue)](https://github.com/python/mypy)

A modern Python project template with pre-configured development, testing, and code quality assurance tools.

## Features

- Configured for Python 3.13+
- Dependency management with Poetry
- Code formatting and linting with Ruff
- Type checking with MyPy
- Automated testing with Pytest
- Pre-commit hooks for code quality assurance
- Organized project structure ready to scale

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
