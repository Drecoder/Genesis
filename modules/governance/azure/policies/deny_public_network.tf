# C:\WS\genesis\modules\governance\azure\policies\deny_public_network.tf
resource "azurerm_policy_definition" "deny_public_network" {
  name         = "deny-public-network"
  policy_type  = "Custom"
  mode         = "Indexed" # Targets resources that support tags and locations 
  display_name = "Deny Public Network Exposure"
  description  = "Prevents creation of resources with public network access enabled"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        # 1. Block all Public IP Address resources 
        {
          field  = "type"
          equals = "Microsoft.Network/publicIPAddresses"
        },
        # 2. Block Storage Accounts if public access is not 'Disabled' [cite: 4, 5]
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
        # 3. Block SQL Servers with public endpoints [cite: 6, 7]
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
      effect = "deny" # Hard enforcement for decentralized environments 
    }
  })

  metadata = jsonencode({
    category = "Network Security"
  })
}