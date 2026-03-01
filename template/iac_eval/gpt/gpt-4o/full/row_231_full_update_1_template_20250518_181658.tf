To meet the business requirement, we will configure a DynamoDB table with server-side encryption enabled using AWS KMS (Key Management Service). The Terraform configuration will include the necessary provider setup for AWS, the creation of a DynamoDB table with specified attributes, and the enabling of server-side encryption using a default AWS-managed KMS key. We will also define the necessary IAM roles and policies to ensure that the DynamoDB table can be accessed securely.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = "alias/aws/dynamodb"
  }

  tags = {
    Environment = "production"
    Name        = "example-table"
  }
}
```
</iac_template>

This configuration sets up a DynamoDB table named "example-table" with server-side encryption enabled using the default AWS-managed KMS key for DynamoDB. The table uses a single attribute "id" as the hash key and is configured with on-demand billing mode. The table is tagged for easy identification and management.