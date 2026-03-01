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
  statement {
    actions = [
      "glacier:UploadArchive",
      "glacier:InitiateMultipartUpload",
      "glacier:AbortMultipartUpload",
      "glacier:CompleteMultipartUpload"
    ]

    resources = [
      aws_glacier_vault.example_vault.arn
    ]

    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["10.0.0.0/16"]  # Example IP range
    }
  }

  statement {
    actions = [
      "glacier:DeleteArchive",
      "glacier:DeleteVault"
    ]

    resources = [
      aws_glacier_vault.example_vault.arn
    ]

    effect = "Deny"

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

# Create and apply vault lock policy
data "aws_iam_policy_document" "vault_lock_policy" {
  statement {
    actions = [
      "glacier:DeleteArchive"
    ]

    resources = [
      aws_glacier_vault.example_vault.arn
    ]

    effect = "Deny"

    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }
}

# Lock the vault with the lock policy
resource "aws_glacier_vault_lock" "vault_lock" {
  complete_lock = true
  policy        = data.aws_iam_policy_document.vault_lock_policy.json
  vault_name    = aws_glacier_vault.example_vault.name
}