provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "cluster_name" {
  description = "Name of the MSK cluster"
  default     = "my-msk-cluster"
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

# Create 3 private subnets in different AZs
resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "msk-private-subnet-${count.index + 1}"
  }
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
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

# Create MSK Cluster
resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = var.cluster_name
  kafka_version         = var.kafka_version
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = aws_subnet.private_subnet[*].id
    security_groups = [aws_security_group.msk_sg.id]

    storage_info {
      ebs_storage_info {
        volume_size = 100
      }
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.msk_config.arn
    revision = aws_msk_configuration.msk_config.latest_revision
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.msk_kms_key.arn
  }

  tags = {
    Environment = "Production"
  }
}

# KMS key for encryption
resource "aws_kms_key" "msk_kms_key" {
  description = "KMS key for MSK cluster encryption"
}

# Internet Gateway
resource "aws_internet_gateway" "msk_igw" {
  vpc_id = aws_vpc.msk_vpc.id

  tags = {
    Name = "msk-igw"
  }
}

# Route Table
resource "aws_route_table" "msk_rt" {
  vpc_id = aws_vpc.msk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.msk_igw.id
  }

  tags = {
    Name = "msk-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.msk_rt.id
}

# Output the MSK cluster ARN
output "msk_cluster_arn" {
  value = aws_msk_cluster.msk_cluster.arn
}

# Output the Zookeeper connection string
output "zookeeper_connect_string" {
  value = aws_msk_cluster.msk_cluster.zookeeper_connect_string
}

# Output the Bootstrap brokers
output "bootstrap_brokers" {
  value = aws_msk_cluster.msk_cluster.bootstrap_brokers
}