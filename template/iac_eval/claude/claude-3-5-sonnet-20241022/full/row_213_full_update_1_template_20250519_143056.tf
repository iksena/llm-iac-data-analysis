I'll help you create a Terraform configuration that sets up an Amazon MSK (Managed Streaming for Apache Kafka) cluster with 3 broker nodes, creates an MSK Connect custom plugin, and establishes a connector using the plugin. Here's a detailed solution:

Description:
This Terraform configuration will:
1. Create a VPC with necessary subnets and security groups for MSK
2. Deploy an MSK cluster with 3 broker nodes across different availability zones
3. Create an S3 bucket to store the Debezium connector plugin
4. Create an MSK Connect custom plugin using the Debezium connector
5. Create an MSK Connect connector that uses the custom plugin
6. Set up necessary IAM roles and policies

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# VPC and Network Configuration
resource "aws_vpc" "msk_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "msk-vpc"
  }
}

resource "aws_subnet" "msk_subnet_1" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "msk-subnet-1"
  }
}

resource "aws_subnet" "msk_subnet_2" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "msk-subnet-2"
  }
}

resource "aws_subnet" "msk_subnet_3" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

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
    cidr_blocks = ["10.0.0.0/16"]
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
  kafka_versions = ["2.8.1"]
  name          = "msk-configuration"

  server_properties = <<PROPERTIES
auto.create.topics.enable=true
delete.topic.enable=true
PROPERTIES
}

# MSK Cluster
resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "msk-cluster"
  kafka_version         = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = [
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
    revision = aws_msk_configuration.msk_config.latest_revision
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }
}

# S3 bucket for connector plugin
resource "aws_s3_bucket" "connector_bucket" {
  bucket = "msk-connect-plugins-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# IAM role for MSK Connect
resource "aws_iam_role" "msk_connect_role" {
  name = "msk-connect-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kafkaconnect.amazonaws.com"
        }
      }
    ]
  })
}

# MSK Connect Custom Plugin
resource "aws_mskconnect_custom_plugin" "debezium" {
  name         = "debezium-connector"
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = aws_s3_bucket.connector_bucket.arn
      file_key   = "debezium.zip"
    }
  }
}

# MSK Connector
resource "aws_mskconnect_connector" "debezium_connector" {
  name = "debezium-connector"

  kafkaconnect_version = "2.7.1"

  capacity {
    provisioned_capacity {
      mcu_count    = 1
      worker_count = 1
    }
  }

  connector_configuration = {
    "connector.class"                = "io.debezium.connector.mysql.MySqlConnector"
    "tasks.max"                      = "1"
    "database.hostname"              = "database-hostname"
    "database.port"                  = "3306"
    "database.user"                  = "admin"
    "database.password"              = "password"
    "database.server.name"           = "mysql-server-1"
    "database.include.list"          = "mydatabase"
    "database.history.kafka.topic"   = "schema-changes.mysql"
    "database.history.kafka.bootstrap.servers" = aws_msk_cluster.kafka_cluster.bootstrap_brokers
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = aws_msk_cluster.kafka_cluster.bootstrap_brokers
      vpc {
        security_groups = [aws_security_group.msk_sg.id]
        subnets        = [
          aws_subnet.msk_subnet_1.id,
          aws_subnet.msk_subnet_2.id,
          aws_subnet.msk_subnet_3.id
        ]
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "NONE"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "TLS"
  }

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.debezium.arn
      revision = aws_mskconnect_custom_plugin.debezium.latest_revision
    }
  }

  service_execution_role_arn = aws_iam_role.msk_connect_role.arn
}
</iac_template>

This configuration creates a complete MSK environment with the following components:

1. A VPC with three subnets across different availability zones
2. Security group for the MSK cluster
3. MSK cluster configuration
4. MSK cluster with 3 broker nodes
5. S3 bucket for storing the connector plugin
6. IAM role for MSK Connect
7. MSK Connect custom plugin for Debezium
8. MSK Connect connector configuration

Note: Before deploying this configuration:
1. Make sure you have the "debezium.zip" file ready to be uploaded to the S3 bucket
2. Update the database connection details in the connector configuration
3. Ensure you have appropriate AWS credentials configured
4. You might need to adjust the security group rules based on your specific requirements
5. The VPC configuration might need to be adjusted based on your network requirements

The configuration uses default values for many parameters but can be customized by adding variables as needed.