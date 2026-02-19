.PHONY: help install tests coverage pre-commit setup-pre-commit pre-commit-autoupdate audit release clean

help: ## Display this help message
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "} ; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	poetry install

tests: ## Run tests in parallel
	poetry run pytest -n auto

coverage: ## Run tests with coverage
	poetry run pytest --cov=calculator --cov-report=term-missing --cov-report=html --cov-fail-under=80

pre-commit: ## Run pre-commit
	poetry run pre-commit run --all-files

setup-pre-commit: ## Setup pre-commit
	poetry run pre-commit install --hook-type commit-msg --hook-type pre-push

pre-commit-update: ## Update pre-commit hooks
	poetry run pre-commit autoupdate

audit: ## Scan dependencies for known vulnerabilities
	poetry run pip-audit

release: ## Bump version, update CHANGELOG and tag locally (no push)
	poetry run semantic-release version --no-push --no-vcs-release

clean: ## Clean build artifacts and caches
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	rm -rf .pytest_cache .mypy_cache build dist *.egg-info .ruff_cache htmlcov .coverage
