I'll help you create a Terraform configuration that sets up an S3 Glacier vault with SNS notification service. This configuration will:

1. Create an S3 Glacier vault
2. Create an SNS topic for notifications
3. Create an IAM role and policy for Glacier to publish notifications to SNS
4. Configure Glacier vault notifications

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates:

1. An AWS Glacier vault named "example-glacier-vault"
2. An SNS topic named "glacier-notifications" to receive notifications
3. An IAM role that Glacier can assume to publish notifications
4. Required IAM policies to allow Glacier to publish to the SNS topic
5. SNS topic policy to allow the Glacier service to publish messages
6. Configures the Glacier vault to send notifications for archive and inventory retrieval completions
7. Outputs the vault name and SNS topic ARN for reference

The configuration is complete and deployable. It sets up all the necessary components for a working Glacier vault with notifications. The vault will send notifications when archive retrievals and inventory retrievals are completed. You can subscribe to the SNS topic to receive these notifications via email, SMS, or other supported endpoints (subscription needs to be set up separately).