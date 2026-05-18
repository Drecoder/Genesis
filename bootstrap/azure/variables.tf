variable "azure_location" {
  type        = string
  description = "The target Azure region for the Genesis bootstrap infrastructure."
  default     = "East US"
}

variable "environment" {
  type        = string
  description = "The targeting environment tier, matching the tree architecture ('dev', 'staging', 'prod')."
  default     = "dev"
}