############################################
# Governance Module - Federated Multi-Cloud
# Shared Policy Standard Across Independent VPCs
############################################

# -------------------------------
# GCP Governance (Business Line A - High Activity)
# -------------------------------
module "gcp_governance" {
  source = "./gcp"

  project_id = var.gcp_project_id
  org_id     = var.org_id
  folder_id  = var.folder_id
}

# -------------------------------
# AWS Governance (Business Line B - Independent Domain)
# -------------------------------
module "aws_governance" {
  source = "./aws"

  count = var.enable_aws ? 1 : 0

  account_id = var.aws_account_id
}

# -------------------------------
# Azure Governance (Business Line C - Independent Domain)
# -------------------------------
module "azure_governance" {
  source = "./azure"

  count = var.enable_azure ? 1 : 0

  subscription_id = var.azure_subscription_id
}

# -------------------------------
# Governance Standardization Layer
# -------------------------------
locals {
  governance_domains = [
    "identity_security",
    "network_security",
    "data_protection"
  ]

  active_clouds = compact([
    "gcp",
    var.enable_aws ? "aws" : "",
    var.enable_azure ? "azure" : ""
  ])
}