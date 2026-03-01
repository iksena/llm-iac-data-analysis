To create a serverless Amazon MSK (Managed Streaming for Apache Kafka) cluster using Terraform, we will define a configuration that sets up the necessary resources in the AWS region `us-east-1`. This includes the MSK cluster itself, along with the necessary IAM roles and policies to allow the cluster to operate. We will also configure the VPC and subnets required for the MSK cluster.

The Terraform configuration will include:
- AWS provider configuration for the `us-east-1` region.
- A VPC with public and private subnets.
- An MSK serverless cluster.
- IAM roles and policies for MSK.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "msk_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "msk_subnet" {
  count             = 2
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.msk_vpc.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {}

resource "aws_msk_serverless_cluster" "example" {
  cluster_name = "example-serverless-cluster"
  vpc_config {
    subnet_ids = aws_subnet.msk_subnet[*].id
  }
}

resource "aws_iam_role" "msk_role" {
  name = "MSKServerlessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kafka.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "msk_policy" {
  name        = "MSKServerlessPolicy"
  description = "Policy for MSK Serverless Cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "msk_policy_attachment" {
  role       = aws_iam_role.msk_role.name
  policy_arn = aws_iam_policy.msk_policy.arn
}
```
</iac_template>

This configuration sets up a serverless MSK cluster in a new VPC with two subnets, and it includes the necessary IAM roles and policies to allow the MSK service to interact with the VPC resources.