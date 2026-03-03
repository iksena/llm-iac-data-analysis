To create a Kendra data source resource with URL exclusion and inclusion patterns, we will define a Terraform configuration that sets up an AWS Kendra data source. This configuration will include the necessary IAM roles and policies to allow Kendra to access the data source. We will specify URL inclusion and exclusion patterns to filter the data that Kendra should index. The configuration will be deployed in the `us-east-1` region.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "kendra_role" {
  name = "KendraDataSourceRole"
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
  name        = "KendraDataSourcePolicy"
  description = "Policy for Kendra data source access"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
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

resource "aws_kendra_data_source" "example" {
  name        = "example-data-source"
  index_id    = "your-kendra-index-id" # Replace with your Kendra index ID
  type        = "S3"
  role_arn    = aws_iam_role.kendra_role.arn

  s3_configuration {
    bucket_name = "your-s3-bucket-name" # Replace with your S3 bucket name
    inclusion_prefixes = [
      "include-prefix/"
    ]
    exclusion_patterns = [
      "exclude-pattern/*"
    ]
  }
}
```
</iac_template>

This Terraform configuration sets up an AWS Kendra data source with specified URL inclusion and exclusion patterns. The IAM role and policy are configured to allow Kendra to access the specified S3 bucket. Make sure to replace placeholders like `your-kendra-index-id` and `your-s3-bucket-name` with actual values from your AWS environment.