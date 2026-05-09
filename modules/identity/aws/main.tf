###########################################################
# AWS Identity Layer - OIDC & Trust Federation
###########################################################

# 1. Establish the OIDC Identity Provider for GitHub Actions
# This is the "Root of Trust" for the Genesis Control Plane.
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.github_oidc_thumbprint]
}

# 2. Deployment Unit (Spoke) Execution Roles
# Each DU gets its own isolated role to ensure "Blast Radius Confinement"[cite: 51].
module "spoke_execution_roles" {
  source   = "./spoke-roles"
  for_each = var.deployment_units

  name               = "genesis-execution-${each.key}"
  oidc_provider_arn  = aws_iam_openid_connect_provider.github.arn
  github_repo        = each.value.repo
  permissions_boundary = var.permissions_boundary_arn
}

# 3. Read-Only Hub Access (Mirroring the Sovereign Root)
# Allows Spokes to see core outputs without write authority[cite: 39, 54].
resource "aws_iam_policy" "hub_read_only" {
  name        = "GenesisHubReadOnly"
  description = "Provides read-only access to the Sovereign Root state for federation [cite: 50]"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = [var.hub_state_bucket_arn, "${var.hub_state_bucket_arn}/*"]
      }
    ]
  })
}