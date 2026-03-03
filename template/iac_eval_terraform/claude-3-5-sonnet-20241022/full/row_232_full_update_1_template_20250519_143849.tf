I'll help you create a Terraform configuration to deploy an AWS DynamoDB table with encryption at rest enabled. The configuration will include:

1. AWS provider configuration for the us-east-1 region
2. A DynamoDB table with:
   - Server-side encryption enabled using AWS managed KMS key
   - A primary key (hash key)
   - Basic capacity settings
   - Point-in-time recovery enabled for better data protection

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table with encryption at rest
resource "aws_dynamodb_table" "encrypted_table" {
  name           = "encrypted-dynamodb-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "ID"
  
  # Enable server-side encryption using AWS managed KMS key
  server_side_encryption {
    enabled = true
  }

  # Enable point-in-time recovery for additional data protection
  point_in_time_recovery {
    enabled = true
  }

  # Define primary key
  attribute {
    name = "ID"
    type = "S"
  }

  # Add tags for better resource management
  tags = {
    Environment = "Production"
    Purpose     = "Secure Data Storage"
  }
}
</iac_template>

This configuration creates a DynamoDB table with the following features:
- Server-side encryption enabled using AWS managed KMS key (AWS owned)
- PAY_PER_REQUEST billing mode (on-demand capacity)
- A string type primary key named "ID"
- Point-in-time recovery enabled for enhanced data protection
- Appropriate tags for resource management

The table will be created in the us-east-1 region and will automatically use AWS managed keys for encryption at rest. This configuration provides a secure and scalable DynamoDB table suitable for storing sensitive data.