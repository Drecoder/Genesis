resource "azurerm_policy_definition" "enforce_tagging" {
  name         = "enforce-required-tags"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Enforce Required Resource Tags"

  description = "Ensures all resources have mandatory governance tags for ownership and cost tracking"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          field = "tags['environment']"
          exists = "false"
        },
        {
          field = "tags['owner']"
          exists = "false"
        },
        {
          field = "tags['costCenter']"
          exists = "false"
        },
        {
          field = "tags['application']"
          exists = "false"
        }
      ]
    }

    then = {
      effect = "deny"
    }
  })

  metadata = jsonencode({
    category = "Governance"
    version  = "1.0.0"
  })
}