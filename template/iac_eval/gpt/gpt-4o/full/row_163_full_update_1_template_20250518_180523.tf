To fulfill the business need, we will create a Terraform configuration that sets up a DynamoDB table in three different AWS regions: us-east-1, us-west-1, and us-west-2. Each region will have its own DynamoDB table with the same configuration. We will define the AWS provider for each region and create a DynamoDB table resource in each of these regions. The table will have a primary key defined, and we will use default values for the table name and attributes.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
  alias  = "useast1"
}

provider "aws" {
  region = "us-west-1"
  alias  = "uswest1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "uswest2"
}

resource "aws_dynamodb_table" "example_useast1" {
  provider = aws.useast1
  name     = "example-table"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "example_uswest1" {
  provider = aws.uswest1
  name     = "example-table"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "example_uswest2" {
  provider = aws.uswest2
  name     = "example-table"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}
```
</iac_template>

This configuration will create a DynamoDB table named "example-table" in each specified region with a simple primary key of type string. The billing mode is set to "PAY_PER_REQUEST" to allow for flexible scaling based on demand.