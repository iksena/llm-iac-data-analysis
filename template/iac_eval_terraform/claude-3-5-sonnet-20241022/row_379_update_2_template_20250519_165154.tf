provider "aws" {
  region = "us-east-1"
}

# Create Glacier Vault
resource "aws_glacier_vault" "archive_vault" {
  name = "long-term-archive-vault"

  tags = {
    Environment = "Production"
    Purpose     = "Long-term archival storage"
  }
}

# Create SNS Topic for notifications
resource "aws_sns_topic" "glacier_notifications" {
  name = "glacier-vault-notifications"
}

# Create SNS Topic Policy
resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.glacier_notifications.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
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

# Create basic vault policy
resource "aws_glacier_vault_policy" "vault_policy" {
  vault_name = aws_glacier_vault.archive_vault.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "glacier:UploadArchive",
          "glacier:InitiateMultipartUpload",
          "glacier:AbortMultipartUpload",
          "glacier:CompleteMultipartUpload"
        ]
        Resource = aws_glacier_vault.archive_vault.arn
      }
    ]
  })
}

# Output the Vault ARN
output "glacier_vault_arn" {
  value       = aws_glacier_vault.archive_vault.arn
  description = "The ARN of the created Glacier vault"
}

# Output the SNS Topic ARN
output "sns_topic_arn" {
  value       = aws_sns_topic.glacier_notifications.arn
  description = "The ARN of the SNS topic for Glacier notifications"
}