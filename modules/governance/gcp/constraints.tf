###########################################################
# GCP Constraints Mapping (Genesis Technical Registry)
###########################################################

locals {
  # ---------------------------------------------------------
  # Network Invariants
  # ---------------------------------------------------------
  network_constraints = {
    disable_external_ips      = "constraints/compute.vmExternalIpAccess"
    skip_default_network      = "constraints/compute.skipDefaultNetworkCreation"
    restrict_shared_vpc_host  = "constraints/compute.restrictSharedVpcHostProjects"
    restrict_vpc_peering      = "constraints/compute.restrictVpcPeering"
    disable_ip_forwarding     = "constraints/compute.vmCanIpForward"
  }

  # ---------------------------------------------------------
  # Identity & Trust Invariants
  # ---------------------------------------------------------
  identity_constraints = {
    domain_restricted_sharing = "constraints/iam.allowedPolicyMemberDomains"
    disable_sa_creation       = "constraints/iam.disableServiceAccountCreation"
    disable_sa_key_creation   = "constraints/iam.disableServiceAccountKeyCreation"
    disable_sa_key_upload     = "constraints/iam.disableServiceAccountKeyUpload"
    restrict_auth_types       = "constraints/iam.restrictServiceAccountUsage"
  }

  # ---------------------------------------------------------
  # Data & Residency Invariants
  # ---------------------------------------------------------
  data_constraints = {
    location_restriction      = "constraints/gcp.resourceLocations"
    restrict_non_cmek_services = "constraints/gcp.restrictNonCmekServices"
    bucket_public_access      = "constraints/storage.publicAccessPrevention"
    uniform_bucket_level      = "constraints/storage.uniformBucketLevelAccess"
  }
}