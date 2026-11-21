.PHONY: help install lock run lint format typecheck tests coverage diff-cover audit deps check build mutation pre-commit setup-pre-commit pre-commit-update release clean

help: ## Display this help message
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "} ; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies (creates .venv; uv fetches the Python in .python-version)
	uv sync --locked

lock: ## Update uv.lock after editing dependencies in pyproject.toml
	uv lock

run: ## Run the application
	uv run calculator

lint: ## Lint code (no auto-fix)
	uv run ruff check --no-fix
	uv run ruff format --check

format: ## Auto-fix lint issues and format code
	uv run ruff check --fix
	uv run ruff format

typecheck: ## Run static type checking
	uv run mypy

tests: ## Run tests in parallel
	uv run pytest -n auto

coverage: ## Run tests with coverage (threshold in pyproject.toml)
	uv run pytest -n auto --cov --cov-report=term-missing --cov-report=html --cov-report=xml

diff-cover: ## Every line changed vs origin/main must be covered (run after coverage)
	uv run diff-cover coverage.xml --config-file pyproject.toml

audit: ## Scan dependencies for known vulnerabilities
	uv run pip-audit --skip-editable

deps: ## Check for unused, missing and transitive dependencies
	uv run deptry .

check: pre-commit coverage diff-cover audit deps ## Run every quality gate (same as CI)

mutation: ## Mutation testing: fails if any mutant survives (an untested behavior)
	uv run mutmut run
	uv run mutmut export-cicd-stats
	@uv run python -c "import json, sys; s = json.load(open('mutants/mutmut-cicd-stats.json')); bad = s['survived'] + s['no_tests'] + s['suspicious'] + s['timeout']; print(f\"{s['killed']}/{s['total']} mutants killed, {bad} not caught\"); sys.exit(1 if bad else 0)"

build: ## Build sdist + wheel into dist/ and validate their metadata
	rm -rf dist
	uv sync --locked --group build
	uv build
	uv run twine check --strict dist/*

pre-commit: ## Run pre-commit
	uv run pre-commit run --all-files

setup-pre-commit: ## Install git hooks (pre-push + commit-msg)
	uv run pre-commit install

pre-commit-update: ## Update pre-commit hooks
	uv run pre-commit autoupdate

release: ## Bump version, update CHANGELOG and tag locally (no push)
	uv sync --locked --group release
	uv run semantic-release version --no-push --no-vcs-release

clean: ## Clean build artifacts and caches
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	rm -rf .pytest_cache .mypy_cache build dist *.egg-info .ruff_cache htmlcov .coverage
