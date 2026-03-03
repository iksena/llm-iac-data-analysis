To fulfill the business need, we will create a DynamoDB table with server-side encryption enabled using AWS managed keys (SSE-S3). This ensures that the data stored in the table is encrypted at rest. We will use the AWS provider to manage the resources in the `us-east-1` region. The table will have a primary key composed of a partition key. We will also define the necessary IAM roles and policies to allow access to the DynamoDB table if needed.

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

  server_side_encryption {
    enabled     = true
    sse_type    = "AES256"
  }

  tags = {
    Environment = "Production"
    Name        = "ExampleDynamoDBTable"
  }
}
```

</iac_template>