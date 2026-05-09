############################################
# GCP Governance Module - Output Contract
############################################

output "policy_ids" {
  description = "The list of organization policy constraints applied by this module"
  value = [
    google_organization_policy.disable_external_ips.constraint,
    google_organization_policy.domain_restricted_sharing.constraint,
    google_organization_policy.location_restriction.constraint,
    google_organization_policy.disable_sa_creation.constraint
  ]
}

output "enforcement_status" {
  description = "Returns the current enforcement mode (enforce vs audit) for downstream validation"
  value       = var.enforcement_mode
}

output "governance_scope" {
  description = "The target ID (Org or Folder) where the platform baseline is enforced"
  value       = coalesce(var.org_id, var.folder_id)
}

output "baseline_version" {
  description = "The version of the Genesis platform baseline applied"
  value       = "1.0.0"
}