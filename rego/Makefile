.POSIX:

OPA = opa
REGAL = regal

all:

check-fmt:
	@echo "Checking Rego formatting"
	@$(OPA) fmt --fail --list .

coverage:
	@echo "Check Rego code coverage"
	@$(OPA) test --coverage --threshold 80 . >/dev/null

fmt:
	@echo "Formatting Rego files"
	@$(OPA) fmt --write .

lint:
	@echo "Linting Rego files"
	@$(REGAL) lint .

test:
	@echo "Unit testing Rego files"
	@$(OPA) test --var-values --verbose .
