The Terraform program will define a DynamoDB table with specified read and write capacity units. The table will be created in the AWS cloud using the AWS provider. The configuration will include the necessary provider setup and the DynamoDB table resource with the specified capacity settings. The table will have a primary key defined for its items.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
```
</iac_template>