############################################
# GCP Org Policies - Network Restrictions
# Controls ingress/egress and exposure
############################################

# -------------------------------
# Disable External IPs (if not already in baseline)
# -------------------------------
resource "google_org_policy_policy" "no_external_ips" {
  name   = "${local.parent}/policies/compute.vmExternalIpAccess"
  parent = local.parent

  spec {
    rules {
      enforce = true
    }
  }
}

# -------------------------------
# Restrict VPC Peering (prevent uncontrolled lateral movement)
# -------------------------------
resource "google_org_policy_policy" "restrict_vpc_peering" {
  name   = "${local.parent}/policies/compute.restrictVpcPeering"
  parent = local.parent

  spec {
    rules {
      enforce = true
    }
  }
}

# -------------------------------
# Restrict Shared VPC Host Projects
# -------------------------------
resource "google_org_policy_policy" "restrict_shared_vpc" {
  name   = "${local.parent}/policies/compute.restrictSharedVpcHostProjects"
  parent = local.parent

  spec {
    rules {
      values {
        allowed_values = [
          "projects/network-host-prod"
        ]
      }
    }
  }
}

# -------------------------------
# Restrict Load Balancer Types (example control)
# -------------------------------
resource "google_org_policy_policy" "restrict_lb_types" {
  name   = "${local.parent}/policies/compute.restrictLoadBalancerCreationForTypes"
  parent = local.parent

  spec {
    rules {
      values {
        denied_values = [
          "EXTERNAL"
        ]
      }
    }
  }
}