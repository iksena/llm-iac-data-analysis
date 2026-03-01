provider "aws" {
  region = "us-east-1"
}

resource "aws_glacier_vault" "example" {
  name = "example-vault"
}

data "aws_iam_policy_document" "glacier_vault_policy" {
  statement {
    actions   = ["glacier:DeleteArchive", "glacier:InitiateJob", "glacier:UploadArchive"]
    resources = [aws_glacier_vault.example.arn]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_glacier_vault_lock" "example" {
  vault_name = aws_glacier_vault.example.name
  policy     = data.aws_iam_policy_document.glacier_vault_policy.json

  complete_lock = true
}