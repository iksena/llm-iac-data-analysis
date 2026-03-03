To fulfill the business requirement, we will create a DynamoDB table with global table replication across two AWS regions: us-west-1 and us-west-2. This setup ensures that the data is replicated and available in both regions, providing high availability and disaster recovery capabilities. We will define the necessary IAM roles and policies to allow DynamoDB to perform replication. The configuration will include the AWS provider setup for both regions and the creation of the DynamoDB table with the specified replication settings.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }

  replica {
    region_name = "us-west-2"
  }
}

resource "aws_iam_role" "dynamodb_replication_role" {
  name = "dynamodb-replication-role"

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

resource "aws_iam_policy" "dynamodb_replication_policy" {
  name        = "dynamodb-replication-policy"
  description = "Policy for DynamoDB replication"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:CreateGlobalTable",
          "dynamodb:UpdateGlobalTable",
          "dynamodb:DescribeGlobalTable",
          "dynamodb:DescribeGlobalTableSettings",
          "dynamodb:UpdateGlobalTableSettings"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_replication_policy" {
  role       = aws_iam_role.dynamodb_replication_role.name
  policy_arn = aws_iam_policy.dynamodb_replication_policy.arn
}
```
</iac_template>