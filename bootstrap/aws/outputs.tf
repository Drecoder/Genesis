output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The unique identifier of the bootstrapped VPC network topology."
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.github.arn
  description = "The Amazon Resource Name (ARN) of the OIDC identity trust bridge."
}

output "environment_tier" {
  value       = var.environment
  description = "The active deployment tier configured for this bootstrap root."
}