###########################################################
# Genesis Global Governance - Output Contract
###########################################################

output "aws_governance_active" {
  description = "Boolean indicating if AWS Service Control Policies are active"
  value       = var.aws_enabled ? true : false
}

output "azure_governance_active" {
  description = "Boolean indicating if Azure Policy Initiatives are active"
  value       = var.azure_enabled ? true : false
}

output "gcp_governance_active" {
  description = "Boolean indicating if GCP Organization Policies are active"
  value       = var.gcp_enabled ? true : false
}

output "global_enforcement_mode" {
  description = "The unified enforcement mode across the platform (enforce/audit)"
  value       = var.enforcement_mode
}

output "triple_cloud_compliance_report" {
  description = "A structured map of all applied policy IDs for cross-cloud auditing"
  value = {
    aws   = var.aws_enabled ? module.aws_governance.policy_ids : []
    azure = var.azure_enabled ? module.azure_governance.policy_ids : []
    gcp   = var.gcp_enabled ? module.gcp_governance.policy_ids : []
  }
}