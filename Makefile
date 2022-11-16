.POSIX:

TERRAFORM = terraform

all:

check-fmt:
	@echo "Checking Terraform formatting style"
	@$(TERRAFORM) fmt -check -recursive

fmt:
	@echo "Formatting Terraform code"
	@$(TERRAFORM) fmt -recursive

init:
	@echo "Initializing Terraform live modules"
	@set -e; \
	find . -type f -not -path '*/.*' -name 'main.tf' | \
		while IFS= read file; do \
			dirname=$$(dirname $$file); \
			echo "Initializing $${dirname}"; \
			$(TERRAFORM) -chdir="$${dirname}" init -backend=false; \
		done

validate: init
	@echo "Validating Terraform live modules"
	@set -e; \
	find . -type f -not -path '*/.*' -name 'main.tf' | \
		while IFS= read file; do \
			dirname=$$(dirname $$file); \
			echo "Validating $${dirname}"; \
			$(TERRAFORM) -chdir="$${dirname}" validate; \
		done
