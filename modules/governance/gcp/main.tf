###########################################################
# GCP Governance Module - Main Orchestrator
###########################################################

# This file intentionally leaves the heavy lifting to the 
# specialized org_policy_*.tf files for better scannability.

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

# ---------------------------------------------------------
# Local logic for determining the target scope
# ---------------------------------------------------------
locals {
  # Ensures we are targeting either an Org or a Folder, but not both or neither.
  is_org_scope    = var.org_id != null && var.org_id != ""
  is_folder_scope = var.folder_id != null && var.folder_id != ""
  
  target_id = local.is_org_scope ? var.org_id : var.folder_id
}

# ---------------------------------------------------------
# Audit Logging (Optional but recommended for the Intelligence Plane)
# ---------------------------------------------------------
# This ensures that all activities within the projects governed 
# by this module are logged to a central location.
resource "google_organization_iam_audit_config" "platform_audit" {
  count   = local.is_org_scope ? 1 : 0
  org_id  = var.org_id
  service = "allServices"

  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
}