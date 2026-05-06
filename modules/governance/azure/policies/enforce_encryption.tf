resource "azurerm_policy_definition" "enforce_encryption" {
  name         = "enforce-encryption"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Enforce Encryption at Rest and Transit"
  description  = "Ensures decentralized workloads use encrypted storage and secure transport (TLS)."

  policy_rule = jsonencode({
    if = {
      anyOf = [
        # 🚫 Deny Storage Accounts without HTTPS
        {
          allOf = [
            { field = "type", equals = "Microsoft.Storage/storageAccounts" },
            { field = "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly", equals = "false" }
          ]
        },
        # 🚫 Deny SQL Servers without Transparent Data Encryption (TDE)
        {
          allOf = [
            { field = "type", equals = "Microsoft.Sql/servers/databases" },
            { field = "Microsoft.Sql/servers/databases/transparentDataEncryption", equals = "Disabled" }
          ]
        },
        # 🚫 Deny Unencrypted Managed Disks
        {
          allOf = [
            { field = "type", equals = "Microsoft.Compute/disks" },
            { field = "Microsoft.Compute/disks/encryption.type", notEquals = "EncryptionAtRestWithCustomerKey" }
          ]
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })

  metadata = jsonencode({
    category = "Data Security"
    version  = "1.0.0"
  })
}