provider "aws" {
  region = "us-east-1"
}

# Variables
variable "email_address" {
  description = "Email address to receive notifications"
  type        = string
  default     = "your-email@example.com"
}

variable "vault_name" {
  description = "Name of the Glacier vault"
  type        = string
  default     = "my-glacier-vault"
}

# Create Glacier Vault
resource "aws_glacier_vault" "vault" {
  name = var.vault_name

  notification {
    sns_topic = aws_sns_topic.glacier_notifications.arn
    events    = ["ArchiveRetrievalCompleted"]
  }
}

# Create SNS Topic
resource "aws_sns_topic" "glacier_notifications" {
  name = "glacier-notifications"
}

# Create SNS Topic Subscription
resource "aws_sns_topic_subscription" "glacier_notification_subscription" {
  topic_arn = aws_sns_topic.glacier_notifications.arn
  protocol  = "email"
  endpoint  = var.email_address
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

# Create IAM Policy for Glacier notifications
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
resource "aws_sns_topic_policy" "glacier_notification_topic_policy" {
  arn = aws_sns_topic.glacier_notifications.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowGlacierNotifications"
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