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