To create a basic Amazon Kendra index using Terraform, we need to define an AWS Kendra index resource. This will include specifying the name of the index, the role ARN that Kendra will assume to access resources, and any optional configurations such as document metadata configuration updates. For this setup, we'll create an IAM role that Kendra can assume, and we'll use the default document metadata configuration updates.

Below is the Terraform configuration that sets up a basic Kendra index with the necessary IAM role.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "kendra_role" {
  name = "KendraServiceRole"
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

resource "aws_iam_role_policy" "kendra_policy" {
  name = "KendraServicePolicy"
  role = aws_iam_role.kendra_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kendra_index" "example" {
  name        = "example-kendra-index"
  role_arn    = aws_iam_role.kendra_role.arn
  description = "A basic Kendra index"

  capacity_units {
    query_capacity_units = 1
    storage_capacity_units = 1
  }

  lifecycle {
    ignore_changes = [document_metadata_configuration_updates]
  }
}
```
</iac_template>

This configuration includes:
- An AWS provider configured for the `us-east-1` region.
- An IAM role (`aws_iam_role.kendra_role`) that Kendra can assume, with a trust relationship allowing the Kendra service to assume the role.
- An IAM role policy (`aws_iam_role_policy.kendra_policy`) that grants permissions to access S3 and CloudWatch, which are commonly needed for Kendra operations.
- An AWS Kendra index (`aws_kendra_index.example`) with a basic setup, including a name, description, and capacity units. The `lifecycle` block is used to ignore changes to `document_metadata_configuration_updates`, allowing the use of default settings.