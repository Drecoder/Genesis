###########################################################
# Azure Identity Layer - Input Contract
###########################################################

variable "tenant_id" {
  type        = string
  description = "The Azure Tenant ID."
}

variable "location" {
  type        = string
  description = "The primary region for identity resources."
}

variable "identity_rg_name" {
  type        = string
  description = "Resource Group for Identity components."
}

variable "deployment_units" {
  description = "Map of Delivery Units for isolation."
  type = map(object({
    repo = string
  }))
}

variable "hub_storage_account_id" {
  type        = string
  description = "ID of the Sovereign Root storage for Read-Only mirroring[cite: 54]."
}