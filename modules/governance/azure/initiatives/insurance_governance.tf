resource "azurerm_policy_set_definition" "insurance_governance" {
  name         = "insurance-governance-initiative"
  display_name = "Insurance Workload Governance Initiative"
  policy_type  = "Custom"

  description = "Enforces baseline security, compliance, and cost governance for insurance workloads"

  # ---------------------------------------
  # POLICY: Deny Public Network Exposure
  # ---------------------------------------
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_public_network.id
    reference_id         = "deny_public_network"
  }

  # ---------------------------------------
  # POLICY: Enforce Encryption
  # ---------------------------------------
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.enforce_encryption.id
    reference_id         = "enforce_encryption"
  }

  # ---------------------------------------
  # POLICY: Enforce Tagging
  # ---------------------------------------
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.enforce_tagging.id
    reference_id         = "enforce_tagging"
  }

  metadata = jsonencode({
    category = "Insurance Governance"
    version  = "1.0.0"
  })
}