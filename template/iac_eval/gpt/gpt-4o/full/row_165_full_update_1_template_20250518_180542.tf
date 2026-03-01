The Terraform program will create an AWS DynamoDB table with specified read and write capacity units. The table will be configured with a primary key consisting of a partition key. The AWS provider will be configured to deploy resources in the `us-east-1` region. The program will ensure that the DynamoDB table is set up with the desired capacity settings.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "example-table"
  }
}
```
</iac_template>