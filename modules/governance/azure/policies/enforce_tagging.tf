resource "azurerm_policy_definition" "enforce_tagging" {
  name         = "enforce-required-tags"
  policy_type  = "Custom"
  mode         = "Indexed" # Evaluates resources that support tags and locations 
  display_name = "Enforce Required Resource Tags"

  description = "Ensures all resources have mandatory governance tags for ownership and cost tracking"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          field = "tags['environment']" # Tracks Prod, Dev, Stage 
          exists = "false"
        },
        {
          field = "tags['owner']" # Identifies the responsible DU [cite: 14]
          exists = "false"
        },
        {
          field = "tags['costCenter']" # Enables financial chargebacks [cite: 14]
          exists = "false"
        },
        {
          field = "tags['application']" # Maps resources to specific services [cite: 14]
          exists = "false"
        }
      ]
    }

    then = {
      effect = "deny" # Blocks the API call if tags are missing 
    }
  })

  metadata = jsonencode({
    category = "Governance"
    version  = "1.0.0"
  })
}