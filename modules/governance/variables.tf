############################################
# Governance Module - Input Contract
# Federated Multi-Cloud Platform Controls
############################################

# -------------------------------
# GCP Context (Primary workload plane)
# -------------------------------
variable "gcp_project_id" {
  description = "GCP project used for provider context (primary workload plane)"
  type        = string
}

variable "org_id" {
  description = "GCP Organization ID for org-level policy enforcement"
  type        = string
  default     = null
}

variable "folder_id" {
  description = "GCP Folder ID for scoped policy enforcement"
  type        = string
  default     = null
}

# -------------------------------
# AWS Context (Independent VPC domain)
# -------------------------------
variable "enable_aws" {
  description = "Enable AWS governance domain"
  type        = bool
  default     = false
}

variable "aws_account_id" {
  description = "AWS Account ID for governance enforcement"
  type        = string
  default     = null
}

# -------------------------------
# Azure Context (Independent VPC domain)
# -------------------------------
variable "enable_azure" {
  description = "Enable Azure governance domain"
  type        = bool
  default     = false
}

variable "azure_subscription_id" {
  description = "Azure Subscription ID for governance enforcement"
  type        = string
  default     = null
}

# -------------------------------
# Governance Mode (Cross-cloud control behavior)
# -------------------------------
variable "enforcement_mode" {
  description = "Defines whether governance is enforced or audited"
  type        = string
  default     = "enforce"

  validation {
    condition     = contains(["enforce", "audit"], var.enforcement_mode)
    error_message = "enforcement_mode must be either 'enforce' or 'audit'."
  }
}

# -------------------------------
# Global Policy Standards (applies to all clouds)
# -------------------------------
variable "allowed_regions" {
  description = "Allowed regions for data residency enforcement (applies across clouds where supported)"
  type        = list(string)
  default     = ["us-*"]
}

variable "allowed_iam_domains" {
  description = "Allowed identity domains for access control"
  type        = list(string)
  default     = []
}