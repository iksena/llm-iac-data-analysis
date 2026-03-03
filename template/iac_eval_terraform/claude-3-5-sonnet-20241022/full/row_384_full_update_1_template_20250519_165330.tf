I'll help you create a Terraform configuration to set up an S3 Glacier vault with an access policy. This configuration will:

1. Create an S3 Glacier vault
2. Attach a vault access policy that allows specific actions
3. Use AWS as the provider in the us-east-1 region

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create Glacier Vault
resource "aws_glacier_vault" "example_vault" {
  name = "example-glacier-vault"

  tags = {
    Environment = "Production"
    Purpose     = "Long-term-storage"
  }
}

# Create Glacier Vault Policy
resource "aws_glacier_vault_policy" "example_policy" {
  vault_name = aws_glacier_vault.example_vault.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "add-read-only-permissions"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "glacier:ListVaults",
          "glacier:DescribeVault",
          "glacier:ListTagsForVault"
        ]
        Resource = aws_glacier_vault.example_vault.arn
      },
      {
        Sid    = "add-write-permissions"
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
        Resource = aws_glacier_vault.example_vault.arn
      }
    ]
  })
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}
</iac_template>

This Terraform configuration creates:

1. An AWS Glacier vault named "example-glacier-vault"
2. A vault access policy that:
   - Allows read-only operations (ListVaults, DescribeVault, ListTagsForVault) to all AWS principals
   - Allows write operations (UploadArchive, InitiateMultipartUpload, etc.) only to the root user of the AWS account
3. Includes appropriate tags for environment and purpose
4. Uses the AWS provider configured for the us-east-1 region

The configuration is complete and deployable. It includes all necessary resources and data sources, and doesn't require any additional variable definitions. The policy is structured to provide secure access controls while allowing necessary operations on the vault.