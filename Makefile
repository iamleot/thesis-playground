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

plan: validate
	@echo "Generating Terraform live modules plans"
	@set -e; \
	find . -type f -not -path '*/.*' -name 'main.tf' | \
		while IFS= read file; do \
			dirname=$$(dirname $$file); \
			echo "Generating plan for $${dirname}"; \
			$(TERRAFORM) -chdir="$${dirname}" plan; \
		done

apply-and-destroy: validate
	@echo "Applying and destroying Terraform live modules plans"
	@set -e; \
	find . -type f -not -path '*/.*' -name 'main.tf' | \
		while IFS= read file; do \
			dirname=$$(dirname $$file); \
			echo "Applying plan for $${dirname}"; \
			$(TERRAFORM) -chdir="$${dirname}" apply -auto-approve; \
			echo "Destroying for $${dirname}"; \
			$(TERRAFORM) -chdir="$${dirname}" apply -destroy \
				-auto-approve; \
		done
