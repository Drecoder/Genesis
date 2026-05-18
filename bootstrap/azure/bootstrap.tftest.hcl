# Establish a completely offline mock for the Azure provider
mock_provider "azurerm" {
  # This block simulates the provider without making real network calls
}

run "verify_azure_bootstrap_outputs" {
  command = plan

# Inject the variable value needed for this specific test case
  variables {
    environment = "staging"
  }
  
  assert {
    condition     = output.resource_group_name == "rg-genesis-bootstrap-staging"
    error_message = "The Azure Resource Group name does not follow the rg-genesis-bootstrap-{env} convention."
  }
  
  assert {
    condition     = output.location == "East US"
    error_message = "The resource group was not targeted to the correct Azure location."
  }
}