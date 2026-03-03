To configure a DynamoDB table with on-demand capacity mode using Terraform, we will define a Terraform configuration that sets up an AWS DynamoDB table with the specified capacity mode. On-demand capacity mode allows the table to automatically scale to accommodate workload demands without requiring capacity planning. We will also include the necessary provider configuration for AWS.

Here is the Terraform HCL program to achieve this:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"  # This sets the table to on-demand capacity mode
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "Production"
    Name        = "ExampleTable"
  }
}
```
</iac_template>

This configuration sets up a DynamoDB table named "example-table" in the "us-west-2" region with on-demand capacity mode, which is specified by setting `billing_mode` to `PAY_PER_REQUEST`. The table has a single attribute "id" of type string, which serves as the hash key. Tags are also added for better resource management and identification.