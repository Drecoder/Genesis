###########################################################
# GCP Network Restriction Policies (Genesis Universal)
###########################################################

# 1. 🚫 Hygiene: Skip Default Network Creation
# Matches the "clean slate" invariant. No automatic 'default' networks in new projects.
resource "google_organization_policy" "skip_default_network" {
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}

# 2. 🚫 Topology: Restrict Shared VPC Host Projects
# Ensures only designated 'Hub' projects can act as Shared VPC hosts.
resource "google_organization_policy" "restrict_shared_vpc_host" {
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/compute.restrictSharedVpcHostProjects"

  list_policy {
    deny {
      all = true
    }
  }
}

# 3. 🚫 Topology: Restrict VPC Peering
# Prevents DUs from creating unauthorized side-channels (peering) between spokes.
# Forces all traffic through the central Hub (Firewall/Inspection).
resource "google_organization_policy" "restrict_vpc_peering" {
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/compute.restrictVpcPeering"

  list_policy {
    deny {
      all = true
    }
  }
}

# 4. 🚫 Security: Disable IP Forwarding
# Prevents VMs from acting as unmanaged routers/NAT gateways within a DU.
resource "google_organization_policy" "disable_ip_forwarding" {
  org_id     = var.org_id
  folder_id  = var.folder_id
  constraint = "constraints/compute.vmCanIpForward"

  list_policy {
    deny {
      all = true
    }
  }
}