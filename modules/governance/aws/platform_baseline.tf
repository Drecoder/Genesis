resource "aws_organizations_policy" "platform_governance_baseline" {
  name         = "platform-governance-baseline"
  description  = "Universal security and compliance guardrails for all decentralized Delivery Units"
  type         = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # 🚫 Universal: Deny disabling security services
      {
        Sid    = "DenySecurityServiceDisabling"
        Effect = "Deny"
        Action = [
          "cloudtrail:DeleteTrail",
          "cloudtrail:StopLogging",
          "config:StopConfigurationRecorder",
          "guardduty:DeleteDetector",
          "securityhub:DisableSecurityHub"
        ]
        Resource = "*"
      },

      # 🚫 Universal: Deny IAM local user creation (Forces OIDC usage)
      {
        Sid    = "DenyPrivilegeEscalation"
        Effect = "Deny"
        Action = [
          "iam:CreateUser",
          "iam:AttachUserPolicy",
          "iam:PutUserPolicy",
          "iam:CreateAccessKey"
        ]
        Resource = "*"
      },

      # 🚫 Universal: Regional Lockdown (Standard US regions)
      {
        Sid    = "DenyOutsideApprovedRegions"
        Effect = "Deny"
        Action = "*"
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = [
              "us-east-1",
              "us-west-2"
            ]
          }
        }
      }
    ]
  })
}