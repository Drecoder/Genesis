###########################################################
# GCP Identity Layer - Output Contract
###########################################################

output "workload_identity_provider_name" {
  description = "The full identifier for the Workload Identity Provider."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "spoke_service_account_emails" {
  description = "Map of isolated DU identities."
  value       = { for k, v in google_service_account.du_sa : k => v.email }
}

output "federation_report" {
  description = "Postural metadata for the Intelligence Plane."
  value = {
    pool_id         = google_iam_workload_identity_pool.genesis_pool.id
    isolation_model = "Attribute-Based Access Control (ABAC)"
    active_spokes   = keys(var.deployment_units)
  }
}