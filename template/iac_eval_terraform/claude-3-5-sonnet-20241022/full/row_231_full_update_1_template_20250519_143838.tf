I'll help you create a Terraform configuration to set up a DynamoDB table with server-side encryption enabled using AWS KMS (Key Management Service). The configuration will include:

1. A DynamoDB table with basic configuration
2. Server-side encryption using AWS managed KMS key
3. Basic table attributes including a primary key
4. AWS provider configuration

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table with encryption enabled
resource "aws_dynamodb_table" "encrypted_table" {
  name           = "encrypted-dynamodb-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  
  # Define primary key attribute
  attribute {
    name = "id"
    type = "S"
  }

  # Enable server-side encryption using AWS managed KMS key
  server_side_encryption {
    enabled = true
  }

  # Add tags for better resource management
  tags = {
    Environment = "Production"
    Purpose     = "Encrypted Data Storage"
  }
}
</iac_template>

This configuration creates:
1. A DynamoDB table named "encrypted-dynamodb-table"
2. Uses PAY_PER_REQUEST billing mode (on-demand capacity)
3. Defines a primary key attribute named "id" of type String
4. Enables server-side encryption using the AWS managed KMS key for DynamoDB
5. Includes relevant tags for resource management

The table will be automatically encrypted at rest using AWS's managed KMS key for DynamoDB (aws/dynamodb). This provides a secure way to store sensitive data while maintaining simplicity in management as AWS handles the key rotation and maintenance.

You can deploy this configuration using standard Terraform commands:
```
terraform init
terraform plan
terraform apply
```