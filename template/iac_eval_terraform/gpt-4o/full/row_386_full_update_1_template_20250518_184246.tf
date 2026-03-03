The Terraform program will create an AWS S3 Glacier vault with a specified access policy. The access policy will be defined using the `aws_iam_policy_document` data source, which allows for the creation of a JSON policy document. This policy will be applied to the Glacier vault, and the vault will be locked using the `aws_glacier_vault_lock` resource to ensure that the policy cannot be changed after it is set. The configuration will include the necessary IAM roles and policies to manage the Glacier vault.

<iac_template>

```hcl
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
```

</iac_template>