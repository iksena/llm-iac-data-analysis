To fulfill the business need, we will create an AWS S3 Glacier vault with a specified access policy. The access policy will define who can access the vault and what actions they can perform. We will use the AWS provider to manage the resources in the `us-east-1` region. The configuration will include the necessary IAM roles and policies to ensure secure access to the Glacier vault.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_glacier_vault" "example" {
  name = "example-glacier-vault"
}

resource "aws_glacier_vault_lock" "example" {
  vault_name = aws_glacier_vault.example.name
  policy     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowFullAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "glacier:*",
      "Resource": "arn:aws:glacier:us-east-1:123456789012:vaults/example-glacier-vault"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "glacier_access_role" {
  name = "glacier-access-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "glacier.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "glacier_access_policy" {
  name        = "glacier-access-policy"
  description = "Policy to allow access to the Glacier vault"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "glacier:*",
      "Resource": "arn:aws:glacier:us-east-1:123456789012:vaults/example-glacier-vault"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "glacier_access" {
  role       = aws_iam_role.glacier_access_role.name
  policy_arn = aws_iam_policy.glacier_access_policy.arn
}
```
</iac_template>

This configuration sets up an S3 Glacier vault with a lock policy that allows full access to any AWS principal. It also creates an IAM role and policy to manage access to the vault. Adjust the account ID in the resource ARN as needed.