I'll help you create a Terraform configuration to deploy a DynamoDB table with custom read and write capacity units in AWS.

Description:
This Terraform configuration will:
1. Set up the AWS provider in the us-east-1 region
2. Create a DynamoDB table with:
   - Name: "demo-dynamodb-table"
   - Billing mode: PROVISIONED
   - Read capacity: 20 units
   - Write capacity: 20 units
   - Hash key: "id" (string type)
   - Basic encryption at rest using AWS managed key

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB Table
resource "aws_dynamodb_table" "demo_table" {
  name           = "demo-dynamodb-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "production"
    Purpose     = "demo"
  }

  # Enable server-side encryption by default using AWS managed key
  server_side_encryption {
    enabled = true
  }
}
</iac_template>

This configuration will create a DynamoDB table with the specified read and write capacity units. The table will have a primary key named "id" of type string. The table will be created in the us-east-1 region and will have server-side encryption enabled using an AWS managed key. The table is also tagged with environment and purpose tags for better resource management.

You can deploy this configuration using:
1. terraform init
2. terraform plan
3. terraform apply

The table will be created with the specified capacity units, and you can modify these values later if needed by updating the configuration and running terraform apply again.