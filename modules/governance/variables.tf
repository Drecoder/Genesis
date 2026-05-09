###########################################################
# Genesis Global Governance - Input Contract
###########################################################

# ---------------------------------------------------------
# Global Enforcement Mode
# ---------------------------------------------------------
variable "enforcement_mode" {
  description = "Global toggle: 'enforce' for hard deny, 'audit' for visibility only."
  type        = string
  default     = "enforce"

  validation {
    condition     = contains(["enforce", "audit"], var.enforcement_mode)
    error_message = "Global enforcement_mode must be 'enforce' or 'audit'."
  }
}

# ---------------------------------------------------------
# AWS Configuration
# ---------------------------------------------------------
variable "aws_enabled" {
  description = "Whether to deploy AWS Service Control Policies"
  type        = bool
  default     = false
}

variable "aws_org_id" {
  description = "AWS Organization ID"
  type        = string
  default     = null
}

variable "aws_allowed_regions" {
  description = "List of regions permitted for AWS Deployment Units"
  type        = list(string)
  default     = ["us-east-1"]
}

# ---------------------------------------------------------
# Azure Configuration
# ---------------------------------------------------------
variable "azure_enabled" {
  description = "Whether to deploy Azure Policy Initiatives"
  type        = bool
  default     = false
}

variable "azure_management_group_id" {
  description = "Target Management Group ID for Azure Policy assignment"
  type        = string
  default     = null
}

# ---------------------------------------------------------
# GCP Configuration
# ---------------------------------------------------------
variable "gcp_enabled" {
  description = "Whether to deploy GCP Organization Policies"
  type        = bool
  default     = false
}

variable "gcp_org_id" {
  description = "GCP Organization ID"
  type        = string
  default     = null
}

variable "gcp_allowed_locations" {
  description = "List of locations permitted for GCP Deployment Units"
  type        = list(string)
  default     = ["US"]
}