###########################################################
# GCP Organization Policy Baseline (Genesis Universal)
###########################################################

# 1. 🚫 Network: Disable External IP (Matches Azure No-Public-IP)
resource "google_organization_policy" "disable_external_ips" {
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    deny {
      all = true
    }
  }
}

# 2. 🚫 Identity: Domain Restricted Sharing (Matches AWS Block-Local-IAM)
# Ensures only identities from approved domains can be granted IAM roles.
resource "google_organization_policy" "domain_restricted_sharing" {
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/iam.allowedPolicyMemberDomains"

  list_policy {
    allow {
      values = var.allowed_iam_domains
    }
  }
}

# 3. 🚫 Residency: Resource Location Restriction (Matches AWS Regional Lockdown)
resource "google_organization_policy" "location_restriction" {
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/gcp.resourceLocations"

  list_policy {
    allow {
      values = var.allowed_locations
    }
  }
}

# 4. 🚫 Trust: Disable Service Account Creation (Forces OIDC Usage)
# Prevents DUs from creating shadow identities outside the Bootstrap trust layer.
resource "google_organization_policy" "disable_sa_creation" {
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/iam.disableServiceAccountCreation"

  boolean_policy {
    enforced = var.enforcement_mode == "enforce" ? true : false
  }
}

# 5. 🚫 Data: Restrict Service Usage (Matches Azure CMEK/Encryption)
# Requires use of Customer Managed Encryption Keys for specific services.
resource "google_organization_policy" "require_cmek" {
  count      = var.require_cmek_for_all_resources ? 1 : 0
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/gcp.restrictNonCmekServices"

  # This logic is often scoped; for a baseline, we deny non-compliant services
  list_policy {
    deny {
      all = true
    }
  }
}