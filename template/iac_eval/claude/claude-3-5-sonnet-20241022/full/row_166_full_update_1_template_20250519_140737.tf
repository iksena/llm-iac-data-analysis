I'll help you create a Terraform configuration to create a DynamoDB table and add an item to it. This configuration will:

1. Set up the AWS provider
2. Create a DynamoDB table with a primary key
3. Add a single item to the DynamoDB table

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB Table
resource "aws_dynamodb_table" "example_table" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"
  
  attribute {
    name = "user_id"
    type = "S"
  }
}

# Add item to DynamoDB Table
resource "aws_dynamodb_table_item" "example_item" {
  table_name = aws_dynamodb_table.example_table.name
  hash_key   = aws_dynamodb_table.example_table.hash_key

  item = jsonencode({
    user_id = {
      S = "001"
    }
    first_name = {
      S = "John"
    }
    last_name = {
      S = "Doe"
    }
    email = {
      S = "john.doe@example.com"
    }
    age = {
      N = "30"
    }
  })
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider in the us-east-1 region
2. Creates a DynamoDB table named "example-table" with:
   - PAY_PER_REQUEST billing mode (on-demand capacity)
   - A hash key (partition key) named "user_id" of type String
3. Creates a DynamoDB table item with:
   - user_id (String): "001"
   - first_name (String): "John"
   - last_name (String): "Doe"
   - email (String): "john.doe@example.com"
   - age (Number): 30

The configuration uses the jsonencode function to properly format the item data according to DynamoDB's requirements. The item is linked to the table using the table's name and hash key attributes.

To deploy this configuration, you would need:
1. AWS credentials configured
2. Terraform installed
3. Run the following commands:
   ```
   terraform init
   terraform plan
   terraform apply
   ```