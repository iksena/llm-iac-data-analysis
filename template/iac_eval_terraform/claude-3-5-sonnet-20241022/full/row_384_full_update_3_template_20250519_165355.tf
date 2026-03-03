I'll provide a corrected version of the template with proper syntax and formatting. Please find it enclosed in the required tags:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

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
        Resource = aws_glacier_vault.example_vault.arn
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
        Resource = aws_glacier_vault.example_vault.arn
      }
    ]
  })
}
</iac_template>

This template will:
1. Set up an AWS provider in the us-east-1 region
2. Create an S3 Glacier vault named "example-glacier-vault"
3. Attach a policy to the vault that:
   - Allows read-only access (list and describe operations) to all AWS principals
   - Allows write access (upload and multipart upload operations) only to the root user of the current AWS account
4. Include appropriate tags for environment and purpose
5. Use the current AWS account ID in the policy

The template uses proper HCL syntax and the jsonencode function for the policy document, which is the recommended way to handle JSON policies in Terraform. All resources are properly declared and referenced.