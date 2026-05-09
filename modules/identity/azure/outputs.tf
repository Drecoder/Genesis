###########################################################
# Azure Identity Layer - Output Handshake
###########################################################

output "client_ids" {
  description = "The Client IDs for GitHub Actions to use during OIDC login."
  value       = { for k, v in azurerm_user_assigned_identity.du_identity : k => v.client_id }
}

output "tenant_id" {
  description = "The Azure Tenant ID for the Federated Identity."
  value       = var.tenant_id
}

output "identity_metadata" {
  description = "Compliance report for the Intelligence Plane."
  value = {
    federation_type = "OIDC"
    isolation_level = "Per-Delivery-Unit"
    active_spokes   = keys(var.deployment_units)
  }
}