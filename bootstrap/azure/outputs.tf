output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "The name of the bootstrapped Azure Resource Group."
}

output "location" {
  value       = azurerm_resource_group.main.location
  description = "The Azure region where the bootstrap resources are deployed."
}