To enable point-in-time recovery for a DynamoDB table using Terraform, we will define a configuration that creates a DynamoDB table with the necessary settings. Point-in-time recovery (PITR) allows you to restore a table to any point in time within the last 35 days. This feature is crucial for data protection and recovery in case of accidental writes or deletes. The Terraform configuration will include the AWS provider setup, the DynamoDB table resource, and the necessary settings to enable PITR.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Environment = "production"
    Name        = "example-table"
  }
}
```
</iac_template>

This configuration sets up a DynamoDB table named "example-table" with point-in-time recovery enabled. The table uses a simple primary key with a hash key named "id" of type string. The billing mode is set to "PAY_PER_REQUEST" to simplify cost management. The table is tagged for easy identification and management.