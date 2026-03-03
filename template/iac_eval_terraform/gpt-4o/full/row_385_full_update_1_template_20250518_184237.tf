To fulfill the business need, we will create an AWS S3 Glacier vault with a Vault Lock policy. The Vault Lock feature allows you to enforce compliance controls on individual Glacier vaults via a lockable policy. This Terraform configuration will define the necessary resources to create a Glacier vault and apply a Vault Lock policy to it. We will use the AWS provider and specify a region where the resources will be deployed. Additionally, we will create an IAM role with the necessary permissions to manage the Glacier vault.

<iac_template>
```hcl
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
```
</iac_template>

This configuration creates a Glacier vault named "example-vault" and applies a Vault Lock policy that denies the deletion of archives from the vault. The policy is locked using the `complete_lock` block, which ensures that the policy cannot be changed or removed, enforcing compliance controls. The `ignore_deletion_error` is set to true to handle any potential errors during the lock completion process.