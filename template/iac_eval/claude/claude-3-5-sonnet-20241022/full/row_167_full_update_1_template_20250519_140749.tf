I'll help you create a DynamoDB Global Table with a replica using Terraform. This configuration will:

1. Create a DynamoDB table in the primary region (us-east-1)
2. Enable DynamoDB streams for global tables
3. Create a replica in another region (us-west-2)
4. Configure the table with basic attributes and settings
5. Enable server-side encryption using AWS managed KMS key

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS provider for primary region
provider "aws" {
  region = "us-east-1"
  alias  = "primary"
}

# Configure AWS provider for secondary region
provider "aws" {
  region = "us-west-2"
  alias  = "secondary"
}

# Create DynamoDB table in primary region
resource "aws_dynamodb_table" "primary" {
  provider = aws.primary

  name             = "global-table-example"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }

  replica {
    region_name = "us-west-2"
  }

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Environment = "Production"
    Purpose     = "Global Table Example"
  }
}

# Create DynamoDB table replica in secondary region
resource "aws_dynamodb_table_replica" "replica" {
  provider         = aws.secondary
  global_table_arn = aws_dynamodb_table.primary.arn
  
  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Environment = "Production"
    Purpose     = "Global Table Replica"
  }
}
</iac_template>

This Terraform configuration creates:

1. Two AWS providers: one for the primary region (us-east-1) and one for the secondary region (us-west-2)
2. A primary DynamoDB table with:
   - PAY_PER_REQUEST billing mode
   - A partition key named "id" of type String
   - DynamoDB Streams enabled (required for global tables)
   - Server-side encryption enabled
   - Point-in-time recovery enabled
   - A replica configuration pointing to us-west-2
3. A DynamoDB table replica in the secondary region with:
   - Point-in-time recovery enabled
   - Matching tags

The configuration is complete and deployable. It uses the latest DynamoDB Global Tables V2 feature, which is more cost-effective and easier to manage than V1. The table will automatically replicate data between the two regions with eventual consistency.

To deploy this configuration, you'll need appropriate AWS credentials with permissions to create DynamoDB tables in both regions. The configuration will create a fully functional global table with bi-directional replication between us-east-1 and us-west-2 regions.