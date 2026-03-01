To address the business need of configuring a custom Time to Live (TTL) attribute for data expiration, we will set up an Amazon DynamoDB table with a TTL attribute. This configuration will allow items in the table to be automatically deleted after a specified time, which is useful for managing data lifecycle and storage costs. We will define a DynamoDB table with a TTL attribute and configure the necessary IAM roles and policies to allow the DynamoDB service to perform the TTL operations.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "expiration_time"
    type = "N"
  }

  ttl {
    attribute_name = "expiration_time"
    enabled        = true
  }

  tags = {
    Name        = "example-table"
    Environment = "dev"
  }
}

resource "aws_iam_role" "dynamodb_ttl_role" {
  name = "dynamodb-ttl-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "dynamodb.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_ttl_policy" {
  name        = "dynamodb-ttl-policy"
  description = "Policy to allow DynamoDB to manage TTL"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:UpdateTimeToLive"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.example.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ttl_policy" {
  role       = aws_iam_role.dynamodb_ttl_role.name
  policy_arn = aws_iam_policy.dynamodb_ttl_policy.arn
}
```
</iac_template>

This Terraform configuration sets up a DynamoDB table with a TTL attribute named `expiration_time`. The TTL is enabled, allowing items to be automatically deleted based on the timestamp in the `expiration_time` attribute. An IAM role and policy are also created to allow DynamoDB to manage the TTL settings.