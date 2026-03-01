The Terraform program will create an AWS DynamoDB table with point-in-time recovery enabled. This feature allows you to restore the table to any point in time within the last 35 days, providing a robust backup and recovery solution. The configuration will include the necessary IAM roles and policies to ensure that the DynamoDB table can be managed securely. The AWS provider will be configured to deploy resources in the `us-east-1` region.

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

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "example-table"
  }
}

resource "aws_iam_role" "dynamodb_role" {
  name = "dynamodb-role"

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

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "dynamodb-policy"
  description = "Policy for DynamoDB table management"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:DescribeTable",
          "dynamodb:ListTables",
          "dynamodb:RestoreTableToPointInTime"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = aws_iam_role.dynamodb_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}
```
</iac_template>