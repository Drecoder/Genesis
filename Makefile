# Genesis Infrastructure Orchestration
# ---------------------------------------------------------
# Variables
TERRAFORM  := terraform
TG         := terragrunt
ENVS       := dev staging prod
PROVIDERS  := aws gcp azure

# Default target
.DEFAULT_GOAL := help

## ---------------------------------------------------------
## FOUNDATION (Bootstrap)
## ---------------------------------------------------------

.PHONY: bootstrap-aws bootstrap-gcp bootstrap-azure
bootstrap-aws: ## Initialize the Root of Trust (Identity/State) for AWS
	@echo "Bootstrapping AWS Foundation..."
	cd bootstrap/aws && $(TERRAFORM) init && $(TERRAFORM) apply

bootstrap-gcp: ## Initialize the Root of Trust (Identity/State) for GCP
	@echo "Bootstrapping GCP Foundation..."
	cd bootstrap/gcp && $(TERRAFORM) init && $(TERRAFORM) apply

## ---------------------------------------------------------
## QUALITY ASSURANCE (The "Senior" Mindset)
## ---------------------------------------------------------

.PHONY: fmt lint validate test
fmt: ## Format all HCL files recursively
	@$(TERRAFORM) fmt -recursive

lint: ## Perform static analysis for best practices (requires tflint)
	@tflint --recursive

validate: ## Check internal consistency of modules
	@find modules -type d -name ".terraform" -prune -o -type d -exec sh -c "cd {} && $(TERRAFORM) validate" \;

test: ## Run infrastructure unit tests
	@go test -v ./tests/...

## ---------------------------------------------------------
## ENVIRONMENT MANAGEMENT
## ---------------------------------------------------------

# Usage: make plan ENV=dev
# Usage: make apply ENV=prod
.PHONY: plan apply destroy

plan: ## View changes for a specific environment (e.g., make plan ENV=dev)
	@if [ -z "$(ENV)" ]; then echo "Error: ENV is required (dev|staging|prod)"; exit 1; fi
	cd environments/$(ENV) && $(TG) plan

apply: ## Execute changes for a specific environment
	@if [ -z "$(ENV)" ]; then echo "Error: ENV is required (dev|staging|prod)"; exit 1; fi
	cd environments/$(ENV) && $(TG) apply

destroy: ## Teardown an environment (Use with caution!)
	@if [ -z "$(ENV)" ]; then echo "Error: ENV is required (dev|staging|prod)"; exit 1; fi
	cd environments/$(ENV) && $(TG) destroy

## ---------------------------------------------------------
## UTILITIES
## ---------------------------------------------------------

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'