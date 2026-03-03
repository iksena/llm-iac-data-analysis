provider "aws" {
  region = "us-east-1"
}

resource "aws_glacier_vault" "example" {
  name = "example-vault"
}

resource "aws_glacier_vault_lock" "example" {
  vault_name = aws_glacier_vault.example.name

  complete_lock {
    ignore_deletion_error = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Define-vault-lock",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "glacier:DeleteArchive",
      "Resource": "arn:aws:glacier:us-east-1:${data.aws_caller_identity.current.account_id}:vaults/${aws_glacier_vault.example.name}"
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}