SOURCE_OBJECTS=app stubs tests dags loadtest
DOCKERFILE=Dockerfile

format.black:
	poetry run black ${SOURCE_OBJECTS}
format.ruff:
	poetry run ruff check --silent --fix --exit-zero ${SOURCE_OBJECTS}
format: format.ruff format.black

lints.format_check:
	poetry run black --check ${SOURCE_OBJECTS}
lints.ruff:
	poetry run ruff check ${SOURCE_OBJECTS}
lints.mypy:
	poetry run mypy ${SOURCE_OBJECTS}
lints.dockerfile:
	hadolint ${DOCKERFILE}
lints: lints.ruff lints.mypy lints.dockerfile
lints.ci: lints.format_check lints.ruff lints.mypy

# IMPORTANT: Run `make setup` before running `make test.unit` the first time.
test.unit:
	poetry run pytest \
		--ignore tests/integration \
		--cov=./app \
		--cov-report=xml:coverage-report-unit-tests.xml \
		--junitxml=coverage-junit-unit-tests.xml \
		--cov-report term
