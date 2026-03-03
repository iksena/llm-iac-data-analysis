provider "aws" {
  region = "us-west-2"
}

# Create Glacier Vault
resource "aws_glacier_vault" "example_vault" {
  name = "example-glacier-vault"

  notification {
    sns_topic = aws_sns_topic.glacier_notifications.arn
    events    = ["ArchiveRetrievalCompleted", "InventoryRetrievalCompleted"]
  }
}

# Create SNS Topic
resource "aws_sns_topic" "glacier_notifications" {
  name = "glacier-notifications"
}

# Create IAM Role for Glacier
resource "aws_iam_role" "glacier_notification_role" {
  name = "glacier-notification-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glacier.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM Policy for Glacier to publish to SNS
resource "aws_iam_role_policy" "glacier_notification_policy" {
  name = "glacier-notification-policy"
  role = aws_iam_role.glacier_notification_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          aws_sns_topic.glacier_notifications.arn
        ]
      }
    ]
  })
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.glacier_notifications.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "GlacierPublishPolicy"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.glacier_notification_role.arn
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.glacier_notifications.arn
      }
    ]
  })
}

# Output the Glacier Vault Name and SNS Topic ARN
output "glacier_vault_name" {
  value = aws_glacier_vault.example_vault.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.glacier_notifications.arn
}