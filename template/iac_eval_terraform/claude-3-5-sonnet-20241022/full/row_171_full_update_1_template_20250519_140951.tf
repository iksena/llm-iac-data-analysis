I'll help you create a Terraform configuration to set up a DynamoDB table with on-demand capacity mode (PAY_PER_REQUEST billing mode) in AWS.

This configuration will:
1. Set up AWS provider for us-east-1 region
2. Create a DynamoDB table named "users-table"
3. Configure the table with:
   - PAY_PER_REQUEST billing mode (on-demand capacity)
   - A partition key (user_id)
   - A sort key (timestamp)
   - Basic attributes
   - Point-in-time recovery enabled
   - Tags for better resource management

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table with on-demand capacity
resource "aws_dynamodb_table" "users_table" {
  name           = "users-table"
  billing_mode   = "PAY_PER_REQUEST"  # This enables on-demand capacity mode
  hash_key       = "user_id"
  range_key      = "timestamp"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Environment = "Production"
    Project     = "UserManagement"
    Terraform   = "true"
  }
}
</iac_template>

This configuration creates a DynamoDB table with on-demand capacity mode, which means you'll only pay for the actual reads and writes you perform, rather than provisioning capacity in advance. The table includes:

1. A partition key (user_id) and sort key (timestamp) for efficient data access
2. Point-in-time recovery for backup and recovery purposes
3. Appropriate tags for resource management
4. PAY_PER_REQUEST billing mode, which is the on-demand capacity mode

The configuration is complete and deployable. You can apply this configuration using `terraform init` followed by `terraform apply`. The table will be created with on-demand capacity mode, and AWS will automatically scale the capacity based on your application's needs.