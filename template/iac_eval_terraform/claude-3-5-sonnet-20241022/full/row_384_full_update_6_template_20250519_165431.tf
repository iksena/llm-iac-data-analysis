I'll create the template with a predefined vault name to avoid self-referential issues.

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
        Resource = "arn:aws:glacier:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:vaults/example-glacier-vault"
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
        Resource = "arn:aws:glacier:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:vaults/example-glacier-vault"
      }
    ]
  })

  tags = {
    Environment = "Production"
    Purpose     = "Long-term-storage"
  }
}
</iac_template>