# ==============================================================================
# GENESIS UNIFIED IAAC & GO TOOLCHAIN ENGINE
# ==============================================================================

# --- Stage 1: Tool Binary Compilation & Fetching ---
FROM alpine:3.19 AS tool-fetcher

# Explicitly pinned tool versions to prevent environmental drift
ARG TERRAFORM_VERSION=1.7.0
ARG TERRAGRUNT_VERSION=0.55.0
ARG TFLINT_VERSION=0.50.0

RUN apk add --no-cache curl unzip

# Fetch and extract Pinned Terraform Binary
RUN curl -sSLo tf.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip tf.zip -d /usr/bin/ \
    && chmod +x /usr/bin/terraform

# Fetch Pinned Terragrunt Binary
RUN curl -sSLo /usr/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
    && chmod +x /usr/bin/terragrunt

# Fetch and extract Pinned TFLint Binary for quality enforcement
RUN curl -sSLo tflint.zip https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip \
    && unzip tflint.zip -d /usr/bin/ \
    && chmod +x /usr/bin/tflint


# --- Stage 2: Final Immutable Runtime ---
FROM golang:1.21-alpine3.19

# Establish local system dependencies for underlying runtime tools
RUN apk add --no-cache \
    git \
    bash \
    make \
    openssh \
    curl \
    jq

# Copy pinned DevOps toolset binaries from the fetcher stage
COPY --from=tool-fetcher /usr/bin/terraform /usr/bin/terraform
COPY --from=tool-fetcher /usr/bin/terragrunt /usr/bin/terragrunt
COPY --from=tool-fetcher /usr/bin/tflint /usr/bin/tflint

# Configure Go and Terraform container operational paths
ENV CGO_ENABLED=0
ENV TF_IN_AUTOMATION=true
ENV GO111MODULE=on

WORKDIR /go/src/genesis

# Define the execution entry point default as an interactive shell proxy
CMD ["/bin/bash"]