###########################################################
# GCP Identity Layer - Workload Identity Federation
###########################################################

# 1. The Workload Identity Pool
# Acts as the logical container for federated identities.
resource "google_iam_workload_identity_pool" "genesis_pool" {
  workload_identity_pool_id = "genesis-pool"
  display_name              = "Genesis Identity Pool"
  description               = "Federated trust for the Genesis Control Plane"
}

# 2. The OIDC Provider
# Links the Pool to the GitHub Actions OIDC issuer.
resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.genesis_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# 3. Delivery Unit Service Accounts (Spokes)
# Isolated identities for each DU to ensure Zero Lateral Movement.
resource "google_service_account" "du_sa" {
  for_each     = var.deployment_units
  account_id   = "genesis-${each.key}"
  display_name = "Genesis Execution Identity for ${each.key}"
}

# 4. Workload Identity User Binding
# Restricts specific DUs to their respective GitHub repos.
resource "google_service_account_iam_member" "oidc_binding" {
  for_each           = var.deployment_units
  service_account_id = google_service_account.du_sa[each.key].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.genesis_pool.name}/attribute.repository/${each.value.repo}"
}

# 5. Read-Only Hub Access (Mirroring the Sovereign Root)
resource "google_storage_bucket_iam_member" "hub_reader" {
  for_each = var.deployment_units
  bucket   = var.hub_state_bucket_name
  role     = "roles/storage.objectViewer"
  member   = "serviceAccount:${google_service_account.du_sa[each.key].email}"
}