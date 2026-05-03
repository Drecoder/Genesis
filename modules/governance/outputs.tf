############################################
# Governance Module - Aggregated Outputs
# Exposes cross-cloud governance contract
############################################

# -------------------------------
# Active Cloud Domains
# -------------------------------
output "active_clouds" {
  description = "List of enabled cloud governance domains"
  value = compact([
    "gcp",
    var.enable_aws ? "aws" : "",
    var.enable_azure ? "azure" : ""
  ])
}

# -------------------------------
# Governance Scope (GCP is primary workload plane, but not a control plane)
# -------------------------------
output "gcp_scope" {
  description = "GCP governance enforcement scope"
  value       = module.gcp_governance.governance_scope
}

# -------------------------------
# AWS Scope (if enabled)
# -------------------------------
output "aws_scope" {
  description = "AWS governance scope (if enabled)"
  value       = try(module.aws_governance[0].governance_scope, null)
}

# -------------------------------
# Azure Scope (if enabled)
# -------------------------------
output "azure_scope" {
  description = "Azure governance scope (if enabled)"
  value       = try(module.azure_governance[0].governance_scope, null)
}

# -------------------------------
# Policy Domain Contract
# -------------------------------
output "governance_domains" {
  description = "Standard governance domains enforced across all clouds"
  value = [
    "identity_security",
    "network_security",
    "data_protection"
  ]
}

# -------------------------------
# Primary Execution Plane Indicator
# -------------------------------
output "primary_execution_plane" {
  description = "Indicates where highest workload density exists (not a control plane)"
  value       = "gcp"
}