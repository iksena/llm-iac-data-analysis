I'll help you create a Terraform configuration to set up an S3 Glacier vault for long-term data archiving in AWS. This configuration will:

1. Create an S3 Glacier vault for storing archived data
2. Set up a vault access policy to control access
3. Configure vault notifications
4. Create a vault lock policy for compliance requirements

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates:

1. An S3 Glacier vault named "long-term-archive-vault"
2. An SNS topic for vault notifications
3. A vault access policy that allows upload and retrieval operations from your AWS account
4. A vault lock policy that prevents deletion of archives less than 365 days old
5. Appropriate notifications for archive and inventory retrieval operations

The configuration includes:
- AWS provider configuration for us-east-1 region
- Necessary IAM policies and permissions
- SNS topic for notifications
- Vault lock policy for compliance
- Output values for the vault and SNS topic ARNs

The vault lock policy ensures that archives cannot be deleted for at least one year, which is a common compliance requirement for long-term archival storage. The notification configuration will send messages to the SNS topic when archive retrievals are completed.

To use this configuration, you would need to:
1. Have appropriate AWS credentials configured
2. Run `terraform init` to initialize the working directory
3. Run `terraform plan` to review the changes
4. Run `terraform apply` to create the resources

Remember that Glacier vault lock policies are permanent once confirmed, so be very careful when implementing them in production.