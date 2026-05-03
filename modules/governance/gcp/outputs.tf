############################################
# GCP Governance Module Outputs
# Exposes enforcement context to platform layers
############################################

# -------------------------------
# Governance Scope (Org or Folder)
# -------------------------------
output "governance_scope" {
  description = "The parent scope where governance policies are applied"
  value       = local.parent
}

# -------------------------------
# Organization ID (if used)
# -------------------------------
output "org_id" {
  description = "GCP Organization ID used for policy enforcement"
  value       = var.org_id
}

# -------------------------------
# Folder ID (if used)
# -------------------------------
output "folder_id" {
  description = "GCP Folder ID used for scoped policy enforcement"
  value       = var.folder_id
}

# -------------------------------
# Policy Coverage Indicator
# -------------------------------
output "enabled_policy_domains" {
  description = "Governance domains enabled in this module"
  value = [
    "constraints",
    "network_security",
    "data_protection",
    "identity_security"
  ]
}