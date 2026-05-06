# C:\WS\genesis\modules\governance\azure\initiatives\platform_baseline.tf
resource "azurerm_policy_set_definition" "platform_baseline" {
  name         = "platform-governance-baseline"
  display_name = "Global Platform Governance Baseline"
  policy_type  = "Custom"
  description  = "Enforces decentralized security, compliance, and metadata standards across all DUs"

  # Standardized Policy References
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_public_network.id
    reference_id         = "deny_public_network"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.enforce_encryption.id
    reference_id         = "enforce_encryption"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.enforce_tagging.id
    reference_id         = "enforce_tagging"
  }

  metadata = jsonencode({
    category = "Platform Governance"
    version  = "1.0.0"
  })
}