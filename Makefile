.PHONY: help install tests coverage pre-commit setup-pre-commit pre-commit-autoupdate clean

help: ## Display this help message
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "} ; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	poetry install

tests: ## Run tests
	poetry run pytest

coverage: ## Run tests with coverage
	poetry run pytest --cov=. --cov-report=html

pre-commit: ## Run pre-commit
	poetry run pre-commit run --all-files

setup-pre-commit: ## Setup pre-commit
	poetry run pre-commit install --hook-type commit-msg --hook-type pre-push

pre-commit-update: ## Update pre-commit hooks
	poetry run pre-commit autoupdate

clean: ## Clean build artifacts and caches
	rm -rf .mypy_cache .pytest_cache __pycache__ src/__pycache__ src/**/__pycache__ \
		src/*/*.egg-info dist build *.egg-info .ruff_cache .coverage \
		htmlcov
