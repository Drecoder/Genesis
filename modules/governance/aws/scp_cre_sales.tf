resource "aws_organizations_policy" "scp_cre_sales_guardrails" {
  name        = "scp-cre-sales-guardrails"
  description = "SCP enforcing security and compliance guardrails for CRE/Sales workloads"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # 🚫 Deny disabling security services
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

      # 🚫 Deny public S3 exposure
      {
        Sid    = "DenyPublicS3Access"
        Effect = "Deny"
        Action = [
          "s3:PutBucketPublicAccessBlock",
          "s3:PutBucketAcl",
          "s3:PutObjectAcl"
        ]
        Resource = "*"
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },

      # 🚫 Deny creation of non-encrypted storage
      {
        Sid    = "DenyUnencryptedStorage"
        Effect = "Deny"
        Action = [
          "s3:CreateBucket",
          "rds:CreateDBInstance",
          "dynamodb:CreateTable"
        ]
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:SecureTransport" = "false"
          }
        }
      },

      # 🚫 Restrict regions (example: only US regions)
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
      },

      # 🚫 Deny IAM privilege escalation paths
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
      }
    ]
  })
}