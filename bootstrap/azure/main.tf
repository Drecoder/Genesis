terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-genesis-bootstrap-${var.environment}"
  location = var.azure_location

  tags = {
    Environment  = var.environment
    Orchestrator = "Genesis"
  }
}