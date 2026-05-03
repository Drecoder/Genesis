############################################
# GCP Org Policies - Data Protection Domain
# Prevents data exfiltration & weak controls
############################################

# -------------------------------
# Require CMEK (Customer-managed encryption)
# -------------------------------
resource "google_org_policy_policy" "require_cmek" {
  name   = "${local.parent}/policies/gcp.requireCmekForDiskCreation"
  parent = local.parent

  spec {
    rules {
      enforce = true
    }
  }
}

# -------------------------------
# Restrict Cloud Storage Public Access
# -------------------------------
resource "google_org_policy_policy" "no_public_buckets" {
  name   = "${local.parent}/policies/storage.publicAccessPrevention"
  parent = local.parent

  spec {
    rules {
      enforce = true
    }
  }
}

# -------------------------------
# Disable Uniform Bucket-Level Access OFF (force it ON)
# -------------------------------
resource "google_org_policy_policy" "uniform_bucket_access" {
  name   = "${local.parent}/policies/storage.uniformBucketLevelAccess"
  parent = local.parent

  spec {
    rules {
      enforce = true
    }
  }
}

# -------------------------------
# Restrict BigQuery Data Location
# -------------------------------
resource "google_org_policy_policy" "bq_location_restriction" {
  name   = "${local.parent}/policies/bigquery.allowedLocations"
  parent = local.parent

  spec {
    rules {
      values {
        allowed_values = [
          "US"
        ]
      }
    }
  }
}