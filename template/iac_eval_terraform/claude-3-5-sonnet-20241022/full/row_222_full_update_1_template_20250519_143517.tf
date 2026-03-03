I'll help you create a DynamoDB table with global replicas across us-east-2 and us-west-2 regions. The configuration will:

1. Set up AWS provider for the primary region (us-east-2)
2. Create a DynamoDB table in us-east-2 (primary region)
3. Configure global tables with a replica in us-west-2
4. Set up basic attributes and capacity settings
5. Enable server-side encryption and point-in-time recovery

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider for primary region
provider "aws" {
  region = "us-east-2"
}

# Configure AWS Provider for secondary region
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# Create DynamoDB table with replica
resource "aws_dynamodb_table" "example_table" {
  name           = "example-global-table"
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

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Environment = "Production"
    Purpose     = "Global Table Example"
  }

  lifecycle {
    ignore_changes = [replica]
  }
}
</iac_template>

This configuration creates:
1. A DynamoDB table in us-east-2 (primary region)
2. A replica in us-west-2
3. Uses PAY_PER_REQUEST billing mode (on-demand capacity)
4. Includes a partition key named "id" of type String
5. Enables server-side encryption
6. Enables point-in-time recovery
7. Enables DynamoDB Streams (required for global tables)
8. Includes basic tags for resource management

The table will automatically replicate data between the two regions, providing low-latency access to data for applications in both regions and disaster recovery capabilities. The lifecycle rule is added to prevent Terraform from trying to manage the replica after creation, which could cause conflicts with DynamoDB's internal replication management.