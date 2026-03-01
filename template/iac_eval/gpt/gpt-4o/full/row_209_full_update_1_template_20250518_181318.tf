To create a serverless Amazon Managed Streaming for Apache Kafka (MSK) cluster with 3 broker nodes using Terraform, we will define a configuration that includes the necessary AWS resources. This will involve setting up the MSK cluster with the specified number of broker nodes, configuring the appropriate IAM roles, and ensuring the cluster is deployed in a specified AWS region. We will also include a VPC and subnets to host the MSK cluster.

Below is the Terraform HCL configuration to achieve this setup:

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

resource "aws_subnet" "msk_subnet_c" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.3.0/24"
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
      aws_subnet.msk_subnet_c.id,
    ]

    security_groups = [aws_security_group.msk_sg.id]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
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
```
</iac_template>

This configuration sets up a VPC with three subnets across different availability zones, a security group to allow traffic, and an MSK cluster with 3 broker nodes. The MSK cluster is configured to use TLS for client-broker communication and in-cluster encryption.