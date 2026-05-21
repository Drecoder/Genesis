# ==============================================================================
# GENESIS MULTI-CLOUD RUNTIME ORCHESTRATION LAYER (ANTI-DRIFT GATEWAY)
# ==============================================================================

IMAGE_NAME   := genesis-toolchain:local
WORKSPACE_DIR:= $(shell pwd)
CONTAINER_DIR:= /go/src/genesis
ENV_FILE     := code-quality.env
REPORTS_DIR  := $(WORKSPACE_DIR)/coverage-reports

# Unified Local Toolchain Runner
DOCKER_RUN := docker run --rm \
	-v "$(WORKSPACE_DIR):$(CONTAINER_DIR)" \
	-w "$(CONTAINER_DIR)" \
	--env-file $(ENV_FILE) \
	-e TF_IN_AUTOMATION=true \
	$(IMAGE_NAME)

.DEFAULT_GOAL := help

# Automated dynamic toolchain generation target
.PHONY: build-toolchain
build-toolchain: ## Build the unified local development container image
	@echo "==> Packaging immutable compiler and toolchain layer..."
	docker build -t $(IMAGE_NAME) .

## ---------------------------------------------------------
## FOUNDATION (Bootstrap Root of Trust via Unified Container)
## ---------------------------------------------------------

.PHONY: bootstrap-aws bootstrap-gcp bootstrap-azure
bootstrap-aws: ## Initialize the Root of Trust (Identity/State) for AWS
	@echo "==> Bootstrapping AWS Foundation..."
	$(DOCKER_RUN) sh -c "cd bootstrap/aws && terraform init && terraform apply -auto-approve"

lint: ## Perform static analysis for best practices via built-in tflint
	@echo "==> Running static analysis lint routines..."
	$(DOCKER_RUN) tflint --recursive