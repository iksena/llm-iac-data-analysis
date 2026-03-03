I'll help you create a Terraform configuration for an Amazon MSK (Managed Streaming for Apache Kafka) cluster with 3 broker nodes in the us-east-2 region. The configuration will include:

1. A VPC with necessary subnets for MSK deployment
2. Security group for MSK cluster
3. MSK cluster configuration with 3 broker nodes
4. Required IAM role and policies
5. Necessary networking components

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-2"
}

# Variables with default values
variable "cluster_name" {
  description = "Name of the MSK cluster"
  default     = "msk-cluster"
}

variable "kafka_version" {
  description = "Version of Apache Kafka"
  default     = "2.8.1"
}

# VPC Configuration
resource "aws_vpc" "msk_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "msk-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "msk_igw" {
  vpc_id = aws_vpc.msk_vpc.id

  tags = {
    Name = "msk-igw"
  }
}

# Subnets for MSK
resource "aws_subnet" "msk_subnet_1" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "msk-subnet-1"
  }
}

resource "aws_subnet" "msk_subnet_2" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "msk-subnet-2"
  }
}

resource "aws_subnet" "msk_subnet_3" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-2c"

  tags = {
    Name = "msk-subnet-3"
  }
}

# Security Group for MSK
resource "aws_security_group" "msk_sg" {
  name        = "msk-security-group"
  description = "Security group for MSK cluster"
  vpc_id      = aws_vpc.msk_vpc.id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.msk_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "msk-security-group"
  }
}

# MSK Configuration
resource "aws_msk_configuration" "msk_config" {
  kafka_versions = [var.kafka_version]
  name          = "${var.cluster_name}-config"

  server_properties = <<PROPERTIES
auto.create.topics.enable=true
delete.topic.enable=true
PROPERTIES
}

# MSK Cluster
resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = var.cluster_name
  kafka_version         = var.kafka_version
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets = [
      aws_subnet.msk_subnet_1.id,
      aws_subnet.msk_subnet_2.id,
      aws_subnet.msk_subnet_3.id
    ]
    storage_info {
      ebs_storage_info {
        volume_size = 100
      }
    }
    security_groups = [aws_security_group.msk_sg.id]
  }

  configuration_info {
    arn      = aws_msk_configuration.msk_config.arn
    revision = 1
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.msk_kms_key.arn
  }

  tags = {
    Name = var.cluster_name
  }
}

# KMS Key for encryption
resource "aws_kms_key" "msk_kms_key" {
  description = "KMS key for MSK cluster encryption"
}

# Output the bootstrap brokers
output "bootstrap_brokers" {
  value = aws_msk_cluster.msk_cluster.bootstrap_brokers
}

output "zookeeper_connect_string" {
  value = aws_msk_cluster.msk_cluster.zookeeper_connect_string
}
</iac_template>

This Terraform configuration creates:
1. A VPC with three subnets across different availability zones
2. Security group allowing Kafka traffic (port 9092) within the VPC
3. MSK configuration with basic server properties
4. KMS key for encryption at rest
5. MSK cluster with 3 broker nodes using kafka.t3.small instances
6. Necessary networking components

The configuration includes:
- 100GB EBS storage per broker
- Basic security settings
- Encryption at rest using KMS
- Output variables for bootstrap brokers and zookeeper connection strings

To deploy this infrastructure:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: This is a basic configuration and might need additional security hardening, networking configuration, and monitoring setup for production use.