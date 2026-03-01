To meet the business requirement, we will create a DynamoDB table with global table replication across two AWS regions: `us-east-2` and `us-west-2`. This setup ensures that the data is replicated and available in both regions, providing high availability and low latency access for users in different geographical locations. We will define the DynamoDB table with a primary key and set up the necessary IAM roles for replication. The Terraform configuration will include the AWS provider setup for both regions.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-2"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

resource "aws_dynamodb_table" "main" {
  name           = "my-global-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  replica {
    region_name = "us-west-2"
  }

  lifecycle {
    ignore_changes = [replica]
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

resource "aws_iam_role_policy" "dynamodb_replication_policy" {
  name = "dynamodb-replication-policy"
  role = aws_iam_role.dynamodb_replication_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
```

</iac_template>

This configuration sets up a DynamoDB table with a global table replica in the `us-west-2` region. The IAM role and policy are created to allow DynamoDB to perform replication operations. The `lifecycle` block with `ignore_changes` is used to prevent Terraform from trying to manage the replica configuration directly, as this is managed by AWS once the table is created.