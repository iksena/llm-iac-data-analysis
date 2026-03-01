I'll help you create a Terraform configuration that sets up an S3 Glacier vault with SNS notification integration. This configuration will:

1. Create an S3 Glacier vault
2. Create an SNS topic for notifications
3. Create an SNS topic policy to allow Glacier notifications
4. Configure Glacier vault notifications to send events to the SNS topic

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates:

1. An AWS Glacier vault named "example-glacier-vault"
2. An SNS topic named "glacier-vault-notifications"
3. An SNS topic policy that allows the Glacier service to publish notifications
4. Configures the Glacier vault to send notifications for archive and inventory retrieval completions

The configuration includes:
- AWS provider configuration for the us-east-1 region
- Proper resource naming and tagging
- SNS topic policy to allow Glacier to publish notifications
- Glacier vault notification configuration
- Output values for both the Glacier vault ARN and SNS topic ARN

The vault will send notifications for two types of events:
- ArchiveRetrievalCompleted
- InventoryRetrievalCompleted

You can deploy this configuration using standard Terraform commands:
```
terraform init
terraform plan
terraform apply
```

After deployment, you can subscribe to the SNS topic to receive notifications about your Glacier vault operations.