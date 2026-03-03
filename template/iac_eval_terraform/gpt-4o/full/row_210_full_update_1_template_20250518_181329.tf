To create a serverless Amazon MSK (Managed Streaming for Apache Kafka) cluster with 3 broker nodes in the `us-east-1` region, we will define a Terraform configuration that sets up the necessary resources. This includes the MSK cluster itself, along with the appropriate IAM roles and policies to allow the cluster to operate. We will use the AWS provider to manage these resources.

The configuration will include:
- An AWS MSK cluster with 3 broker nodes.
- Necessary IAM roles and policies for MSK to function.
- A VPC with subnets to host the MSK cluster.

Below is the Terraform HCL configuration to achieve this setup.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "msk_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "msk_subnet_a" {
  vpc_id     = aws_vpc.msk_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "msk_subnet_b" {
  vpc_id     = aws_vpc.msk_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "msk_subnet_c" {
  vpc_id     = aws_vpc.msk_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
}

resource "aws_msk_cluster" "example" {
  cluster_name = "example-cluster"
  kafka_version = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = "kafka.m5.large"
    client_subnets = [
      aws_subnet.msk_subnet_a.id,
      aws_subnet.msk_subnet_b.id,
      aws_subnet.msk_subnet_c.id
    ]
    security_groups = [aws_security_group.msk_sg.id]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster = true
    }
  }
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

resource "aws_iam_role_policy" "msk_policy" {
  name = "MSKPolicy"
  role = aws_iam_role.msk_iam_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeSubnets",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}
```
</iac_template>