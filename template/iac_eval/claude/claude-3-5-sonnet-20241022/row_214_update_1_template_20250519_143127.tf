provider "aws" {
  region = "us-east-1"
}

# VPC and Networking (MSK requires VPC)
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
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "msk_log_group" {
  name              = "/aws/msk/cluster"
  retention_in_days = 30
}

# S3 Bucket
resource "aws_s3_bucket" "msk_bucket" {
  bucket = "msk-data-bucket-${random_string.random.result}"
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# MSK Cluster
resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "msk-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = [aws_subnet.msk_subnet_1.id, aws_subnet.msk_subnet_2.id, aws_subnet.msk_subnet_3.id]
    security_groups = [aws_security_group.msk_sg.id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.msk_kms_key.arn
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    cloudwatch_logs {
      enabled   = true
      log_group = aws_cloudwatch_log_group.msk_log_group.name
    }
    s3 {
      enabled = true
      bucket  = aws_s3_bucket.msk_bucket.id
      prefix  = "msk-logs/"
    }
  }
}

# KMS Key for MSK encryption
resource "aws_kms_key" "msk_kms_key" {
  description = "KMS key for MSK cluster encryption"
}

# Kinesis Firehose
resource "aws_kinesis_firehose_delivery_stream" "msk_firehose" {
  name        = "msk-firehose"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.msk_bucket.arn
    prefix     = "firehose-data/"
  }
}

# IAM Role for Firehose
resource "aws_iam_role" "firehose_role" {
  name = "msk-firehose-role"

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

# MSK Connect Custom Plugin
resource "aws_mskconnect_custom_plugin" "debezium_plugin" {
  name         = "debezium-plugin"
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = aws_s3_bucket.msk_bucket.arn
      file_key   = "debezium.zip"
    }
  }
}

# MSK Connect Connector
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
    "database.hostname"              = "localhost"
    "database.port"                  = "3306"
    "database.user"                  = "debezium"
    "database.password"              = "dbz"
    "database.server.id"             = "1"
    "database.server.name"           = "mysql-server-1"
    "database.whitelist"             = "inventory"
    "database.history.kafka.topic"   = "schema-changes.inventory"
    "database.history.kafka.bootstrap.servers" = aws_msk_cluster.kafka_cluster.bootstrap_brokers
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = aws_msk_cluster.kafka_cluster.bootstrap_brokers

      vpc {
        security_groups = [aws_security_group.msk_sg.id]
        subnets        = [aws_subnet.msk_subnet_1.id, aws_subnet.msk_subnet_2.id, aws_subnet.msk_subnet_3.id]
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "NONE"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "PLAINTEXT"
  }

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.debezium_plugin.arn
      revision = aws_mskconnect_custom_plugin.debezium_plugin.latest_revision
    }
  }

  service_execution_role_arn = aws_iam_role.connector_role.arn
}

# IAM Role for MSK Connect
resource "aws_iam_role" "connector_role" {
  name = "msk-connector-role"

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