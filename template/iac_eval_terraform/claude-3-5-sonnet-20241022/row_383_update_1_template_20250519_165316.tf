provider "aws" {
  region = "us-east-1"
}

# Create SNS Topic
resource "aws_sns_topic" "glacier_vault_notifications" {
  name = "glacier-vault-notifications"
}

# Create SNS Topic Policy
resource "aws_sns_topic_policy" "glacier_notifications_policy" {
  arn = aws_sns_topic.glacier_vault_notifications.arn

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
        Resource = aws_sns_topic.glacier_vault_notifications.arn
      }
    ]
  })
}

# Create Glacier Vault
resource "aws_glacier_vault" "example_vault" {
  name = "example-glacier-vault"

  notification {
    sns_topic = aws_sns_topic.glacier_vault_notifications.arn
    events    = ["ArchiveRetrievalCompleted", "InventoryRetrievalCompleted"]
  }

  tags = {
    Environment = "production"
    Purpose     = "long-term-storage"
  }
}

# Output the Glacier Vault ARN
output "glacier_vault_arn" {
  value = aws_glacier_vault.example_vault.arn
}

# Output the SNS Topic ARN
output "sns_topic_arn" {
  value = aws_sns_topic.glacier_vault_notifications.arn
}