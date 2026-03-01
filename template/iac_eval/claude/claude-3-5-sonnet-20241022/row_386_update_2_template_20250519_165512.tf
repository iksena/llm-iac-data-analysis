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
    sid = "UploadPolicy"
    
    actions = [
      "glacier:UploadArchive",
      "glacier:InitiateMultipartUpload",
      "glacier:AbortMultipartUpload",
      "glacier:CompleteMultipartUpload"
    ]

    effect = "Allow"

    principals {
      type = "*"
      identifiers = ["*"]
    }

    resources = [
      "${aws_glacier_vault.example_vault.arn}/*"
    ]
  }

  statement {
    sid = "DenyDeletionPolicy"
    
    actions = [
      "glacier:DeleteArchive",
      "glacier:DeleteVault"
    ]

    effect = "Deny"

    principals {
      type = "*"
      identifiers = ["*"]
    }

    resources = [
      "${aws_glacier_vault.example_vault.arn}/*"
    ]
  }
}

# Attach the policy to the vault
resource "aws_glacier_vault_policy" "vault_policy" {
  vault_name = aws_glacier_vault.example_vault.name
  policy     = data.aws_iam_policy_document.vault_policy.json
}

# Lock policy document
data "aws_iam_policy_document" "lock_policy" {
  statement {
    sid = "EnforceLockPolicy"
    
    effect = "Deny"
    
    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = [
      "glacier:DeleteArchive"
    ]

    resources = [
      "${aws_glacier_vault.example_vault.arn}/*"
    ]
  }
}

# Apply vault lock
resource "aws_glacier_vault_lock" "lock" {
  complete_lock = true
  policy        = data.aws_iam_policy_document.lock_policy.json
  vault_name    = aws_glacier_vault.example_vault.name
}