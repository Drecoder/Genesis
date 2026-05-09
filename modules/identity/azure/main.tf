###########################################################
# Azure Identity Layer - OIDC Federation (Genesis)
###########################################################

# 1. The Workload Identity (The "Spoke" Identity)
# Each Delivery Unit (DU) receives its own Managed Identity.
resource "azurerm_user_assigned_identity" "du_identity" {
  for_each            = var.deployment_units
  name                = "id-genesis-${each.key}"
  location            = var.location
  resource_group_name = var.identity_rg_name
}

# 2. Federated Identity Credential
# Maps the specific GitHub Repo to the Azure Identity.
# This ensures Zero Lateral State Movement between spokes.
resource "azurerm_federated_identity_credential" "github_federation" {
  for_each            = var.deployment_units
  name                = "fed-genesis-${each.key}"
  resource_group_name = var.identity_rg_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.du_identity[each.key].id
  subject             = "repo:${each.value.repo}:ref:refs/heads/main"
}

# 3. Read-Only Hub Access (Mirroring the Sovereign Root) [cite: 40, 54]
resource "azurerm_role_assignment" "hub_read_only" {
  for_each             = var.deployment_units
  scope                = var.hub_storage_account_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.du_identity[each.key].principal_id
}