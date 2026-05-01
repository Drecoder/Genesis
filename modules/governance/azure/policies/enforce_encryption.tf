resource "azurerm_policy_definition" "deny_public_network" {
  name         = "deny-public-network"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Deny Public Network Exposure"

  description = "Prevents deployment of resources with public network access enabled"

  policy_rule = jsonencode({
    if = {
      anyOf = [

        # 🚫 Public IP resources
        {
          field  = "type"
          equals = "Microsoft.Network/publicIPAddresses"
        },

        # 🚫 Storage accounts with public access enabled
        {
          allOf = [
            {
              field  = "type"
              equals = "Microsoft.Storage/storageAccounts"
            },
            {
              field  = "Microsoft.Storage/storageAccounts/publicNetworkAccess"
              equals = "Enabled"
            }
          ]
        },

        # 🚫 SQL servers with public access enabled
        {
          allOf = [
            {
              field  = "type"
              equals = "Microsoft.Sql/servers"
            },
            {
              field  = "Microsoft.Sql/servers/publicNetworkAccess"
              equals = "Enabled"
            }
          ]
        }

      ]
    }

    then = {
      effect = "deny"
    }
  })

  metadata = jsonencode({
    category = "Network Security"
    version  = "1.0.0"
  })
}