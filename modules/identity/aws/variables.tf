###########################################################
# AWS Identity Layer - Input Contract
###########################################################

# ---------------------------------------------------------
# OIDC Trust Configuration
# ---------------------------------------------------------
variable "github_oidc_thumbprint" {
  description = "The CA thumbprint for GitHub Actions OIDC (Root of Trust)"
  type        = string
  default     = "6938fd4d98bab03faadb97b34396831e3780aea1" # Standard GitHub OIDC Thumbprint
}

# ---------------------------------------------------------
# Federated Deployment Units (Spokes)
# ---------------------------------------------------------
variable "deployment_units" {
  description = "Map of Delivery Units to their respective GitHub repositories for role mapping"
  type = map(object({
    repo = string
  }))
  # Example: { "app-alpha" = { repo = "org/repo-alpha" } }
}

# ---------------------------------------------------------
# Sovereign Root Protection (The Hub)
# ---------------------------------------------------------
variable "hub_state_bucket_arn" {
  description = "The ARN of the Sovereign Root state bucket for read-only mirroring"
  type        = string
}

# ---------------------------------------------------------
# Blast Radius Containment (Permissions Boundary)
# ---------------------------------------------------------
variable "permissions_boundary_arn" {
  description = "MANDATORY: IAM Policy ARN to act as a guardrail for all federated roles"
  type        = string
}