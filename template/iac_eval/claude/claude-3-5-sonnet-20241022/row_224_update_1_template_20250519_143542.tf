provider "aws" {
  region = "us-west-1"
  alias  = "primary"
}

# Configure AWS Provider for replica region
provider "aws" {
  region = "us-west-2"
  alias  = "replica"
}

# Create DynamoDB table in primary region
resource "aws_dynamodb_table" "primary_table" {
  provider = aws.primary

  name           = "multi-region-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }

  replica {
    region_name = "us-west-2"
  }

  tags = {
    Environment = "Production"
    Purpose     = "Multi-Region Deployment"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }
}

# Create IAM role for DynamoDB replication
resource "aws_iam_role" "dynamodb_replication" {
  provider = aws.primary
  name     = "dynamodb-replication-role"

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

# Create IAM policy for DynamoDB replication
resource "aws_iam_role_policy" "dynamodb_replication_policy" {
  provider = aws.primary
  name     = "dynamodb-replication-policy"
  role     = aws_iam_role.dynamodb_replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:*"
        ]
        Resource = [
          aws_dynamodb_table.primary_table.arn,
          "${aws_dynamodb_table.primary_table.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:CreateGrant",
          "kms:DescribeKey",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })
}