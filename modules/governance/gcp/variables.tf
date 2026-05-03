############################################
# GCP Governance Module - Input Contract
############################################

# -------------------------------
# Project Context (for provider binding)
# -------------------------------
variable "project_id" {
  description = "GCP Project ID used for provider context (required for provider initialization)"
  type        = string
}

# -------------------------------
# Organization Scope
# -------------------------------
variable "org_id" {
  description = "GCP Organization ID for org-level policy enforcement"
  type        = string
  default     = null
}

# -------------------------------
# Folder Scope (alternative to org-level enforcement)
# -------------------------------
variable "folder_id" {
  description = "GCP Folder ID for scoped policy enforcement when org_id is not used"
  type        = string
  default     = null
}

# -------------------------------
# Enforcement Mode
# -------------------------------
variable "enforcement_mode" {
  description = "Controls whether policies are enforced or audited only"
  type        = string
  default     = "enforce"

  validation {
    condition     = contains(["enforce", "audit"], var.enforcement_mode)
    error_message = "enforcement_mode must be either 'enforce' or 'audit'."
  }
}

# -------------------------------
# Allowed Locations (Data Residency Control)
# -------------------------------
variable "allowed_locations" {
  description = "List of allowed GCP locations for data residency enforcement"
  type        = list(string)
  default     = ["US"]
}

# -------------------------------
# Allowed IAM Domains
# -------------------------------
variable "allowed_iam_domains" {
  description = "List of allowed domains for IAM binding"
  type        = list(string)
  default     = []
}