I'll help you create a Terraform configuration that sets up an S3 Glacier vault and integrates it with AWS Data Lifecycle Manager (DLM). This configuration will:

1. Create an S3 Glacier vault for long-term data archival
2. Set up a vault lock policy
3. Create necessary IAM roles for DLM
4. Configure DLM lifecycle policy to manage data lifecycle

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "vault_name" {
  description = "Name of the Glacier vault"
  type        = string
  default     = "my-archive-vault"
}

# Create Glacier Vault
resource "aws_glacier_vault" "archive_vault" {
  name = var.vault_name

  notification {
    sns_topic = aws_sns_topic.glacier_notifications.arn
    events    = ["ArchiveRetrievalCompleted", "InventoryRetrievalCompleted"]
  }

  tags = {
    Environment = "Production"
    Purpose     = "Long-term archival"
  }
}

# Create SNS Topic for Glacier notifications
resource "aws_sns_topic" "glacier_notifications" {
  name = "glacier-vault-notifications"
}

# Create IAM Role for DLM
resource "aws_iam_role" "dlm_lifecycle_role" {
  name = "dlm-lifecycle-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "dlm.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM Policy for DLM
resource "aws_iam_role_policy" "dlm_lifecycle" {
  name = "dlm-lifecycle-policy"
  role = aws_iam_role.dlm_lifecycle_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumes",
          "glacier:CreateVault",
          "glacier:DeleteArchive",
          "glacier:DescribeVault",
          "glacier:UploadArchive"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create DLM Lifecycle Policy
resource "aws_dlm_lifecycle_policy" "glacier_policy" {
  description        = "DLM lifecycle policy for Glacier archival"
  execution_role_arn = aws_iam_role.dlm_lifecycle_role.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "2 weeks retention schedule"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times        = ["23:45"]
      }

      retain_rule {
        count = 14
      }

      tags_to_add = {
        SnapshotCreator = "DLM"
      }

      copy_tags = false
    }

    target_tags = {
      Backup = "true"
    }
  }

  tags = {
    Name = "glacier-lifecycle-policy"
  }
}

# Create Glacier Vault Policy
resource "aws_glacier_vault_lock" "vault_lock" {
  vault_name = aws_glacier_vault.archive_vault.name
  complete_lock = false

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "glacier:DescribeVault",
          "glacier:ListTagsForVault",
          "glacier:InitiateJob",
          "glacier:GetJobOutput",
          "glacier:UploadArchive",
          "glacier:InitiateMultipartUpload",
          "glacier:UploadMultipartPart",
          "glacier:CompleteMultipartUpload",
          "glacier:AbortMultipartUpload"
        ]
        Resource = aws_glacier_vault.archive_vault.arn
        Condition = {
          Bool = {
            "aws:SecureTransport": "true"
          }
        }
      }
    ]
  })
}

# Outputs
output "glacier_vault_arn" {
  value = aws_glacier_vault.archive_vault.arn
  description = "ARN of the created Glacier vault"
}

output "dlm_role_arn" {
  value = aws_iam_role.dlm_lifecycle_role.arn
  description = "ARN of the DLM IAM role"
}
</iac_template>

This Terraform configuration creates:

1. An S3 Glacier vault for storing archived data
2. An SNS topic for vault notifications
3. IAM role and policy for DLM to manage the lifecycle
4. DLM lifecycle policy that creates daily snapshots and retains them for 14 days
5. Glacier vault lock policy with secure transport requirement
6. Relevant outputs for reference

The configuration includes:
- Secure transport requirement in the vault policy
- Daily snapshot creation at 23:45
- 14-day retention period for snapshots
- Proper IAM permissions for DLM
- SNS notifications for vault events
- Appropriate tagging for resources

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Make sure you have proper AWS credentials configured before applying this configuration.