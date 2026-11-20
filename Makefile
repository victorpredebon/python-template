.PHONY: help install run lint format typecheck tests coverage audit deps check build pre-commit setup-pre-commit pre-commit-update release clean

help: ## Display this help message
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "} ; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	poetry install

run: ## Run the application
	poetry run calculator

lint: ## Lint code (no auto-fix)
	poetry run ruff check --no-fix
	poetry run ruff format --check

format: ## Auto-fix lint issues and format code
	poetry run ruff check --fix
	poetry run ruff format

typecheck: ## Run static type checking
	poetry run mypy

tests: ## Run tests in parallel
	poetry run pytest -n auto

coverage: ## Run tests with coverage (threshold in pyproject.toml)
	poetry run pytest -n auto --cov --cov-report=term-missing --cov-report=html

audit: ## Scan dependencies for known vulnerabilities
	poetry run pip-audit --skip-editable

deps: ## Check for unused, missing and transitive dependencies
	poetry run deptry .

check: lint typecheck coverage audit deps ## Run every quality gate (same as CI)

build: ## Build sdist + wheel into dist/ and validate their metadata
	rm -rf dist
	poetry install --with build
	poetry check --strict
	poetry build
	poetry run twine check --strict dist/*

pre-commit: ## Run pre-commit
	poetry run pre-commit run --all-files

setup-pre-commit: ## Install git hooks (pre-push + commit-msg)
	poetry run pre-commit install

pre-commit-update: ## Update pre-commit hooks
	poetry run pre-commit autoupdate

release: ## Bump version, update CHANGELOG and tag locally (no push)
	poetry install --with release
	poetry run semantic-release version --no-push --no-vcs-release

clean: ## Clean build artifacts and caches
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	rm -rf .pytest_cache .mypy_cache build dist *.egg-info .ruff_cache htmlcov .coverage
