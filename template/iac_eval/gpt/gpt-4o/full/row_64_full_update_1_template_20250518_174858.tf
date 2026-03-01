To fulfill the business need, we will create a Terraform configuration that sets up an Amazon Kinesis Firehose Delivery Stream with an Amazon OpenSearch Serverless destination. This configuration will include the necessary IAM roles and policies to allow Kinesis Firehose to deliver data to the OpenSearch Serverless domain. We will also configure the OpenSearch Serverless domain and ensure that the Firehose delivery stream is properly connected to it.

Here's the Terraform configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_delivery_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "firehose_policy" {
  name        = "firehose_delivery_policy"
  description = "Policy for Kinesis Firehose to deliver data to OpenSearch Serverless"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "es:ESHttpPut",
          "es:ESHttpPost"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attachment" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_policy.arn
}

resource "aws_opensearchserverless_collection" "example" {
  name = "example-collection"
}

resource "aws_kinesis_firehose_delivery_stream" "firehose_to_opensearch" {
  name        = "firehose-to-opensearch"
  destination = "opensearch"

  opensearch_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    domain_arn         = aws_opensearchserverless_collection.example.arn
    index_name         = "example-index"
    type_name          = "_doc"
    buffering_interval = 300
    buffering_size     = 5
  }
}
```
</iac_template>

This configuration includes:

- An AWS provider configured for the `us-west-2` region.
- An IAM role (`firehose_role`) with a trust relationship allowing Kinesis Firehose to assume the role.
- An IAM policy (`firehose_policy`) that grants permissions to write to the OpenSearch Serverless domain.
- An attachment of the policy to the IAM role.
- An OpenSearch Serverless collection (`example`).
- A Kinesis Firehose delivery stream (`firehose_to_opensearch`) configured to deliver data to the OpenSearch Serverless collection.