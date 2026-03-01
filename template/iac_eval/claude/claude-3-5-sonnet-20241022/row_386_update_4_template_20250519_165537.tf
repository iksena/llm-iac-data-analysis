provider "aws" {
  region = "us-west-2"
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
    resources = ["arn:aws:glacier:us-west-2:*:vaults/example-glacier-vault"]
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }
}

# Create Glacier Vault with policy
resource "aws_glacier_vault" "example_vault" {
  name = "example-glacier-vault"
  
  access_policy = data.aws_iam_policy_document.vault_policy.json

  tags = {
    Environment = "Production"
  }
}

# Define the lock policy
data "aws_iam_policy_document" "lock_policy" {
  version = "2012-10-17"
  statement {
    effect = "Deny"
    actions = [
      "glacier:DeleteArchive"
    ]
    resources = ["arn:aws:glacier:us-west-2:*:vaults/example-glacier-vault"]
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