I'll help you create a DynamoDB table with global replicas across us-west-1 and us-west-2 regions. The primary table will be created in us-west-1, with a replica in us-west-2. The table will have basic configurations including a partition key, billing mode, and global secondary indexes.

Here's the Terraform configuration:

<iac_template>
# Configure AWS Provider for primary region
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
</iac_template>

This Terraform configuration does the following:

1. Sets up two AWS providers: one for us-west-1 (primary) and one for us-west-2 (replica)
2. Creates a DynamoDB table in the primary region (us-west-1) with:
   - PAY_PER_REQUEST billing mode
   - A partition key named "id" of type String
   - Stream enabled for replication
   - Point-in-time recovery enabled
   - Server-side encryption enabled
   - A replica configuration for us-west-2
3. Creates necessary IAM roles and policies for DynamoDB replication

The table will automatically replicate data between the two regions, providing high availability and disaster recovery capabilities. The configuration includes necessary security features like encryption and proper IAM permissions for replication.

To deploy this, you would need appropriate AWS credentials with permissions to create DynamoDB tables, IAM roles, and policies in both regions.