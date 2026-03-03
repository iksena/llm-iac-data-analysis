I'll help you create a Terraform configuration that sets up an S3 Glacier vault with SNS notifications for archive retrieval completion. This configuration will:

1. Create an S3 Glacier vault
2. Create an SNS topic for notifications
3. Create an SNS topic subscription for email notifications
4. Set up the necessary IAM roles and policies
5. Configure Glacier vault notifications

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates:

1. An AWS Glacier vault that will send notifications when archive retrieval is completed
2. An SNS topic that will receive these notifications
3. An email subscription to the SNS topic
4. The necessary IAM roles and policies to allow Glacier to publish to the SNS topic
5. A policy for the SNS topic to allow Glacier to publish to it

To use this configuration:

1. Replace the default email address in the `email_address` variable with your actual email address
2. After applying the configuration, you'll receive an email to confirm the SNS subscription
3. Once confirmed, you'll receive notifications when archive retrievals are completed

Note that when you first subscribe to the SNS topic, AWS will send a confirmation email that you must accept before receiving notifications.

The configuration uses the us-east-1 region by default. You can modify the provider block to use a different region if needed.