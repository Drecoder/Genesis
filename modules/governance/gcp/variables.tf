# -------------------------------
# Service Account Control
# -------------------------------
variable "block_service_account_creation" {
  description = "If true, prevents the creation of new Service Accounts to mandate OIDC/Workload Identity usage"
  type        = bool
  default     = true
}

# -------------------------------
# Encryption Contract (CMEK)
# -------------------------------
variable "require_cmek_for_all_resources" {
  description = "Forces the use of Customer Managed Encryption Keys (CMEK) for all supported resources (Storage, Compute, SQL)"
  type        = bool
  default     = true
}

# -------------------------------
# Public Access Prevention
# -------------------------------
variable "block_external_ip_access" {
  description = "If true, enforces a constraint that prevents VMs from having external/public IP addresses"
  type        = bool
  default     = true
}