provider "aws" {
  region = "us-west-2"
}

# Create Glacier Vault
resource "aws_glacier_vault" "example_vault" {
  name = "example-glacier-vault"

  tags = {
    Environment = "Production"
  }
}

# Define the vault access policy
data "aws_iam_policy_document" "vault_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "glacier:UploadArchive",
      "glacier:InitiateMultipartUpload",
      "glacier:AbortMultipartUpload",
      "glacier:CompleteMultipartUpload"
    ]
    resources = [aws_glacier_vault.example_vault.arn]
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }
}

# Attach the policy to the vault
resource "aws_glacier_vault_policy" "vault_policy" {
  vault_name = aws_glacier_vault.example_vault.name
  policy     = data.aws_iam_policy_document.vault_policy.json
}

# Define the lock policy
data "aws_iam_policy_document" "lock_policy" {
  version = "2012-10-17"
  statement {
    effect = "Deny"
    actions = [
      "glacier:DeleteArchive"
    ]
    resources = [aws_glacier_vault.example_vault.arn]
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }
}

# Apply the vault lock
resource "aws_glacier_vault_lock" "lock" {
  vault_name    = aws_glacier_vault.example_vault.name
  complete_lock = true
  policy        = data.aws_iam_policy_document.lock_policy.json
}