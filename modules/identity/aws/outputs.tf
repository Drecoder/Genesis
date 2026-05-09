###########################################################
# AWS Identity Layer - Output Contract
###########################################################

output "oidc_provider_arn" {
  description = "The ARN of the GitHub OIDC Provider (The Root of Trust)"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "spoke_execution_role_arns" {
  description = "Map of DU keys to their isolated IAM Execution Role ARNs"
  value       = { for k, v in module.spoke_execution_roles : k => v.role_arn }
}

output "hub_read_only_policy_arn" {
  description = "ARN of the policy allowing read-only access to the Sovereign Root"
  value       = aws_iam_policy.hub_read_only.arn
}

output "federation_metadata" {
  description = "Metadata for the Intelligence Plane to verify identity posture"
  value = {
    provider_url      = aws_iam_openid_connect_provider.github.url
    enforced_boundary = var.permissions_boundary_arn
    active_spokes     = keys(var.deployment_units)
  }
}