To fulfill the business need, we will create a managed Amazon MSK (Managed Streaming for Apache Kafka) cluster with 3 broker nodes in the `us-east-2` region. The configuration will include the necessary IAM roles and security groups to ensure the cluster is secure and accessible. We will use the AWS provider to manage the resources.

The Terraform configuration will include:
- An AWS provider configuration for the `us-east-2` region.
- An IAM role for the MSK cluster.
- A security group to control access to the MSK cluster.
- The MSK cluster itself with 3 broker nodes.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_role" "msk_role" {
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
  name   = "MSKClusterPolicy"
  role   = aws_iam_role.msk_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:ResetNetworkInterfaceAttribute"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_security_group" "msk_sg" {
  name        = "msk_security_group"
  description = "Security group for MSK cluster"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_msk_cluster" "example" {
  cluster_name           = "example-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = data.aws_subnet_ids.default.ids
    security_groups = [aws_security_group.msk_sg.id]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
```
</iac_template>