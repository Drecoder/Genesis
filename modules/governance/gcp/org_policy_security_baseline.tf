############################################
# GCP Org Policies - Identity Security
# Controls IAM, authentication, and key usage
############################################

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
# Disable Service Account Key Upload
# -------------------------------
resource "google_org_policy_policy" "disable_sa_key_upload" {
  name   = "${local.parent}/policies/iam.disableServiceAccountKeyUpload"
  parent = local.parent

  spec {
    rules {
      enforce = true
    }
  }
}

# -------------------------------
# Restrict IAM Member Domains
# -------------------------------
resource "google_org_policy_policy" "restrict_iam_domains" {
  name   = "${local.parent}/policies/iam.allowedPolicyMemberDomains"
  parent = local.parent

  spec {
    rules {
      values {
        allowed_values = [
          "your-company.com"
        ]
      }
    }
  }
}

# -------------------------------
# Enforce OS Login (centralized SSH control)
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