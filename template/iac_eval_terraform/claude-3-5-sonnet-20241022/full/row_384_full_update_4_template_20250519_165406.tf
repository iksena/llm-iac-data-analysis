I apologize for the confusion. You're right. Let me correct the template. The correct resource type for Glacier vault policy is `aws_glacier_vault_lock_policy`. Here's the corrected version:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Create Glacier Vault
resource "aws_glacier_vault" "example_vault" {
  name = "example-glacier-vault"

  access_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadOnlyAccess"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "glacier:ListVaults",
          "glacier:DescribeVault",
          "glacier:ListTagsForVault"
        ]
        Resource = "arn:aws:glacier:${data.aws_caller_identity.current.region}:${data.aws_caller_identity.current.account_id}:vaults/${aws_glacier_vault.example_vault.name}"
      },
      {
        Sid    = "WriteAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "glacier:UploadArchive",
          "glacier:InitiateMultipartUpload",
          "glacier:AbortMultipartUpload",
          "glacier:CompleteMultipartUpload"
        ]
        Resource = "arn:aws:glacier:${data.aws_caller_identity.current.region}:${data.aws_caller_identity.current.account_id}:vaults/${aws_glacier_vault.example_vault.name}"
      }
    ]
  })

  tags = {
    Environment = "Production"
    Purpose     = "Long-term-storage"
  }
}
</iac_template>

This corrected version:
1. Removes the separate policy resource and includes the policy directly in the vault resource using the `access_policy` argument
2. Properly constructs the ARN for the vault resource
3. Uses the correct attribute names and structure
4. Maintains the same permissions and access controls as before

The policy is now properly attached to the Glacier vault during creation, allowing for both read-only access to list and describe the vault, and write access for uploading archives to authorized users in your AWS account.