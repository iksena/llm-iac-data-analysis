provider "aws" {
  region = "us-east-1"
}

# Create Glacier Vault
resource "aws_glacier_vault" "archive_vault" {
  name = "long-term-archive-vault"

  notification {
    sns_topic = aws_sns_topic.glacier_notifications.arn
    events    = ["ArchiveRetrievalCompleted", "InventoryRetrievalCompleted"]
  }

  tags = {
    Environment = "Production"
    Purpose     = "Long-term archival storage"
  }
}

# Create SNS Topic for Glacier notifications
resource "aws_sns_topic" "glacier_notifications" {
  name = "glacier-vault-notifications"
}

# Create SNS Topic Policy
resource "aws_sns_topic_policy" "glacier_notifications_policy" {
  arn = aws_sns_topic.glacier_notifications.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "GlacierNotifications"
        Effect = "Allow"
        Principal = {
          Service = "glacier.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.glacier_notifications.arn
      }
    ]
  })
}

# Create Vault Access Policy
resource "aws_glacier_vault_policy" "vault_policy" {
  vault_name = aws_glacier_vault.archive_vault.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadWriteAccess"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "glacier:UploadArchive",
          "glacier:InitiateMultipartUpload",
          "glacier:AbortMultipartUpload",
          "glacier:CompleteMultipartUpload",
          "glacier:DescribeVault",
          "glacier:GetVaultAccessPolicy",
          "glacier:ListParts",
          "glacier:ListMultipartUploads",
          "glacier:InitiateJob",
          "glacier:GetJobOutput"
        ]
        Resource = aws_glacier_vault.archive_vault.arn
        Condition = {
          StringLike = {
            "aws:PrincipalArn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:*"
          }
        }
      }
    ]
  })
}

# Create Vault Lock Policy
resource "aws_glacier_vault_lock" "vault_lock" {
  vault_name = aws_glacier_vault.archive_vault.name
  complete_lock = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnforceLockRetention"
        Effect = "Deny"
        Principal = {
          AWS = "*"
        }
        Action = [
          "glacier:DeleteArchive"
        ]
        Resource = aws_glacier_vault.archive_vault.arn
        Condition = {
          NumericLessThan = {
            "glacier:ArchiveAgeInDays" = "365"
          }
        }
      }
    ]
  })
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Output the Vault ARN
output "glacier_vault_arn" {
  value = aws_glacier_vault.archive_vault.arn
  description = "The ARN of the created Glacier vault"
}

# Output the SNS Topic ARN
output "sns_topic_arn" {
  value = aws_sns_topic.glacier_notifications.arn
  description = "The ARN of the SNS topic for Glacier notifications"
}