I'll help you create a Terraform configuration that sets up an S3 Glacier vault with an access policy and locks it using vault lock. This configuration will:

1. Create an S3 Glacier vault
2. Define an IAM policy document for vault access
3. Attach the policy to the vault
4. Create a vault lock policy to prevent future policy changes

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-west-2 region
2. Creates a Glacier vault named "example-glacier-vault"
3. Defines a vault access policy that:
   - Allows upload operations from a specific IP range (10.0.0.0/16)
   - Denies deletion operations for all users
4. Attaches the access policy to the vault
5. Creates a vault lock policy that permanently denies deletion operations
6. Applies the vault lock with complete_lock = true, which makes the policy immutable

Important notes:
- Once the vault lock is applied with complete_lock = true, it CANNOT be reversed
- The IP range (10.0.0.0/16) in the policy is an example and should be adjusted to your needs
- The configuration includes basic security measures but should be reviewed and adjusted according to your security requirements
- The vault name must be unique within your account in the specified region