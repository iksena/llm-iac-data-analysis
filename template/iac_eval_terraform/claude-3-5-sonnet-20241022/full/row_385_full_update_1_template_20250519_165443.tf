I'll help you create a Terraform configuration to set up an S3 Glacier vault with a Vault Lock policy. This configuration will:

1. Create an S3 Glacier vault
2. Create a Vault Lock policy that enforces compliance controls
3. Initialize and complete the vault lock process

The vault lock policy will enforce a 365-day retention period for archives and deny deletion of archives during this period, which is common for compliance requirements.

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create the Glacier Vault
resource "aws_glacier_vault" "compliance_vault" {
  name = "compliance-vault"

  tags = {
    Environment = "Production"
    Purpose     = "Compliance Storage"
  }
}

# Create the Vault Lock Policy
data "aws_iam_policy_document" "vault_lock_policy" {
  statement {
    effect = "Deny"
    actions = [
      "glacier:DeleteArchive"
    ]
    resources = [
      "${aws_glacier_vault.compliance_vault.arn}/*"
    ]
    condition {
      test     = "NumericLessThan"
      variable = "glacier:ArchiveAgeInDays"
      values   = ["365"]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

# Apply the Vault Lock Policy
resource "aws_glacier_vault_lock" "vault_lock" {
  complete_lock = true
  policy        = data.aws_iam_policy_document.vault_lock_policy.json
  vault_name    = aws_glacier_vault.compliance_vault.name
}
</iac_template>

This Terraform configuration creates:

1. An AWS Glacier vault named "compliance-vault"
2. A vault lock policy that:
   - Denies deletion of archives less than 365 days old
   - Applies to all principals
   - Protects all archives in the vault
3. A vault lock that permanently applies the policy to the vault

Important notes:
- The `complete_lock = true` setting means this is a permanent lock that cannot be removed once applied
- The region is set to us-east-1, but you can modify this as needed
- The vault name uses hyphens instead of underscores as per AWS naming requirements
- The policy enforces a 365-day retention period, but this can be adjusted based on your compliance requirements

This configuration provides a secure, compliant storage solution for long-term data retention with enforced retention policies.