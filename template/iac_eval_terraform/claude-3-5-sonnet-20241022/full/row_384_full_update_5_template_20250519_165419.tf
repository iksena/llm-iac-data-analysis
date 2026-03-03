I'll fix the template by using a data source for the AWS region and correct the resource ARN construction.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Get current AWS region
data "aws_region" "current" {}

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
        Resource = "arn:aws:glacier:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:vaults/${aws_glacier_vault.example_vault.name}"
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
        Resource = "arn:aws:glacier:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:vaults/${aws_glacier_vault.example_vault.name}"
      }
    ]
  })

  tags = {
    Environment = "Production"
    Purpose     = "Long-term-storage"
  }
}
</iac_template>