###########################################################
# Genesis Global Governance Orchestrator
# This module aggregates cloud-specific policy baselines
###########################################################

# 1. AWS Governance (Service Control Policies)
module "aws_governance" {
  source = "./aws"
  
  enabled            = var.aws_enabled
  org_id             = var.aws_org_id
  allowed_regions    = var.aws_allowed_regions
  enforcement_mode   = var.enforcement_mode
}

# 2. Azure Governance (Policy Initiatives)
module "azure_governance" {
  source = "./azure"
  
  enabled            = var.azure_enabled
  management_group   = var.azure_management_group_id
  enforcement_mode   = var.enforcement_mode
}

# 3. GCP Governance (Org Policy Constraints)
module "gcp_governance" {
  source = "./gcp"
  
  enabled            = var.gcp_enabled
  org_id             = var.gcp_org_id
  allowed_locations  = var.gcp_allowed_locations
  enforcement_mode   = var.enforcement_mode
}