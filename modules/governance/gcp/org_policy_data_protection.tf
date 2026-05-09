###########################################################
# GCP Data Protection Policies (Genesis Universal)
###########################################################

# 1. 🚫 Privacy: Enforce Public Access Prevention (Cloud Storage)
# Matches the Azure "Deny Public Endpoint" standard.
# Prevents any bucket from being made public at the resource level.
resource "google_organization_policy" "enforce_public_access_prevention" {
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/storage.publicAccessPrevention"

  boolean_policy {
    enforced = true
  }
}

# 2. 🚫 Security: Restrict Non-CMEK Services
# Matches the Azure "Mandatory CMK" invariant.
# Ensures that resources (like Disks or Cloud SQL) cannot be created 
# unless they are protected by a Customer-Managed Encryption Key.
resource "google_organization_policy" "restrict_non_cmek_services" {
  count      = var.require_cmek_for_all_resources ? 1 : 0
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/gcp.restrictNonCmekServices"

  list_policy {
    deny {
      all = true
    }
  }
}

# 3. 🚫 Security: Uniform Bucket-Level Access
# Ensures that IAM is the only way to control access to data, 
# disabling the legacy (and often risky) ACL system.
resource "google_organization_policy" "enforce_uniform_bucket_level_access" {
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/storage.uniformBucketLevelAccess"

  boolean_policy {
    enforced = true
  }
}

# 4. 🚫 Residency: Restrict Resource Usage
# Re-enforces the "Residency" invariant specifically for data-bearing services.
resource "google_organization_policy" "data_residency" {
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/gcp.resourceLocations"

  list_policy {
    allow {
      values = var.allowed_locations
    }
  }
}