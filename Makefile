export PYTHONPATH := $(PWD)/src

tests:
	pytest src -vv

tests-coverage:
	pytest --cov=src src/ -vv --cov-report=html

lint:
	pre-commit run --all-files

pre-commit-install:
	pre-commit install --install-hooks

pre-commit-update:
	pre-commit autoupdate
