export PYTHONPATH := $(PWD)/src

tests:
	pytest src

lint:
	pre-commit run --all-files

pre-commit-install:
	pre-commit install

pre-commit-update:
	pre-commit autoupdate
