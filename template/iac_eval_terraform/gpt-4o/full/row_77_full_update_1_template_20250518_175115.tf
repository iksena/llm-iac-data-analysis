To create a basic Amazon Kendra index with user group resolution configuration using Terraform, we will define a Kendra index resource. Amazon Kendra is an intelligent search service powered by machine learning. The user group resolution configuration allows Kendra to resolve user groups for access control. We will also include the necessary IAM roles and policies to allow Kendra to function properly. The configuration will be set up in the `us-east-1` region.

Here is the Terraform HCL configuration:

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "kendra_role" {
  name = "KendraIndexRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "kendra_policy" {
  name        = "KendraIndexPolicy"
  description = "Policy for Kendra index access"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kendra_policy_attachment" {
  role       = aws_iam_role.kendra_role.name
  policy_arn = aws_iam_policy.kendra_policy.arn
}

resource "aws_kendra_index" "example" {
  name        = "example-kendra-index"
  role_arn    = aws_iam_role.kendra_role.arn
  edition     = "DEVELOPER_EDITION"

  user_token_configurations {
    json_token_type_configuration {
      user_name_attribute_field = "username"
      group_attribute_field     = "groups"
    }
  }
}
```

</iac_template>

This configuration sets up a basic Kendra index with user group resolution using JSON token type configuration. It includes the necessary IAM role and policy to allow Kendra to access required AWS services. The Kendra index is created in the `us-east-1` region with the `DEVELOPER_EDITION` edition, which is suitable for development and testing purposes.