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