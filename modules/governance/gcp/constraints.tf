############################################
# GCP Organization Policy Constraints
# Enforces platform-wide governance guardrails
############################################

# -------------------------------
# Variables
# -------------------------------
variable "org_id" {
  description = "GCP Organization ID (preferred for global enforcement)"
  type        = string
  default     = null
}

variable "folder_id" {
  description = "GCP Folder ID (used if org_id is not set)"
  type        = string
  default     = null
}

locals {
  parent = var.org_id != null ? "organizations/${var.org_id}" : "folders/${var.folder_id}"
}

# -------------------------------
# Disable External IPs on VMs
# -------------------------------
resource "google_org_policy_policy" "disable_external_ip" {
  name   = "${local.parent}/policies/compute.vmExternalIpAccess"
  parent = local.parent

  spec {
    rules {
      enforce = true
    }
  }
}

# -------------------------------
# Restrict Resource Locations
# -------------------------------
resource "google_org_policy_policy" "allowed_locations" {
  name   = "${local.parent}/policies/gcp.resourceLocations"
  parent = local.parent

  spec {
    rules {
      values {
        allowed_values = [
          "in:us-locations" # restrict to US regions
        ]
      }
    }
  }
}

# -------------------------------
# Disable Service Account Key Creation
# -------------------------------
resource "google_org_policy_policy" "disable_sa_keys" {
  name   = "${local.parent}/policies/iam.disableServiceAccountKeyCreation"
  parent = local.parent

  spec {
    rules {
      enforce = true
    }
  }
}

# -------------------------------
# Require OS Login (SSH control)
# -------------------------------
resource "google_org_policy_policy" "require_os_login" {
  name   = "${local.parent}/policies/compute.requireOsLogin"
  parent = local.parent

  spec {
    rules {
      enforce = true
    }
  }
}