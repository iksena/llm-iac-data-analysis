To create a managed Amazon MSK (Managed Streaming for Apache Kafka) cluster with encryption at rest, we will define a Terraform configuration that sets up the necessary AWS resources. This includes the MSK cluster itself, a VPC with subnets for the cluster, and the necessary IAM roles and policies. The MSK cluster will be configured to use AWS-managed encryption at rest.

The configuration will include:
- An AWS provider configuration.
- A VPC with public and private subnets.
- An MSK cluster with encryption at rest enabled.
- Necessary IAM roles and policies for MSK.

Below is the Terraform HCL configuration for this setup:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "msk_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "msk_subnet_a" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "msk_subnet_b" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "msk_sg" {
  vpc_id = aws_vpc.msk_vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_msk_cluster" "example" {
  cluster_name           = "example-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = [aws_subnet.msk_subnet_a.id, aws_subnet.msk_subnet_b.id]
    security_groups = [aws_security_group.msk_sg.id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.msk_kms_key.arn
  }
}

resource "aws_kms_key" "msk_kms_key" {
  description = "KMS key for MSK encryption at rest"
}

resource "aws_iam_role" "msk_iam_role" {
  name = "MSKClusterRole"

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

resource "aws_iam_role_policy_attachment" "msk_policy_attachment" {
  role       = aws_iam_role.msk_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonMSKFullAccess"
}
```
</iac_template>

This configuration sets up a basic MSK cluster with encryption at rest using a KMS key. The VPC and subnets are created to host the MSK cluster, and a security group is configured to allow traffic. An IAM role is created and attached with the necessary permissions for MSK.