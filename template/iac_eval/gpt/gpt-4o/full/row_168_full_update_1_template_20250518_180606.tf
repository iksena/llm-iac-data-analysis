To fulfill the business need, we will create a DynamoDB Accelerator (DAX) cluster using Terraform. The DAX cluster will be configured with a node type of `dax.r4.large` and a replication factor of 1, which means it will have a single node. We will also set up the necessary IAM roles and policies to allow the DAX cluster to operate. The configuration will be deployed in the `us-west-2` region.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "dax_service_role" {
  name = "DAXServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "dax.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "dax_policy" {
  name   = "DAXPolicy"
  role   = aws_iam_role.dax_service_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:*",
          "cloudwatch:*",
          "logs:*",
          "sns:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_dax_cluster" "example" {
  cluster_name      = "example-dax-cluster"
  node_type         = "dax.r4.large"
  replication_factor = 1
  iam_role_arn      = aws_iam_role.dax_service_role.arn

  parameter_group_name = "default.dax1.0"
}
```
</iac_template>

This configuration sets up a DAX cluster with the specified node type and replication factor. It also creates an IAM role with the necessary permissions for the DAX service to interact with other AWS services.