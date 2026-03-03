provider "aws" {
  region = "us-east-1"
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# VPC and Networking
resource "aws_vpc" "msk_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "msk-vpc"
  }
}

resource "aws_internet_gateway" "msk_igw" {
  vpc_id = aws_vpc.msk_vpc.id

  tags = {
    Name = "msk-igw"
  }
}

resource "aws_subnet" "msk_subnet" {
  count             = 3
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "msk-subnet-${count.index + 1}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Security Group
resource "aws_security_group" "msk_sg" {
  name_prefix = "msk-sg-"
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

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "msk_log_group" {
  name              = "/aws/msk/cluster-${random_string.suffix.result}"
  retention_in_days = 30
}

# S3 Bucket
resource "aws_s3_bucket" "msk_bucket" {
  bucket = "msk-data-bucket-${random_string.suffix.result}"
}

resource "aws_s3_bucket_versioning" "msk_bucket_versioning" {
  bucket = aws_s3_bucket.msk_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# KMS Key
resource "aws_kms_key" "msk_kms" {
  description             = "KMS key for MSK cluster encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# MSK Cluster
resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "msk-cluster-${random_string.suffix.result}"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = aws_subnet.msk_subnet[*].id
    security_groups = [aws_security_group.msk_sg.id]

    storage_info {
      ebs_storage_info {
        volume_size = 100
      }
    }
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.msk_kms.arn
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
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
    broker_logs {
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

  tags = {
    Name = "msk-cluster"
  }
}

# Kinesis Firehose Role
resource "aws_iam_role" "firehose_role" {
  name = "msk-firehose-role-${random_string.suffix.result}"

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

resource "aws_iam_role_policy" "firehose_policy" {
  name = "msk-firehose-policy"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.msk_bucket.arn,
          "${aws_s3_bucket.msk_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Kinesis Firehose
resource "aws_kinesis_firehose_delivery_stream" "msk_firehose" {
  name        = "msk-firehose-${random_string.suffix.result}"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.msk_bucket.arn
    prefix     = "firehose-data/"
  }
}

# MSK Connect Custom Plugin
resource "aws_mskconnect_custom_plugin" "debezium" {
  name         = "debezium-plugin-${random_string.suffix.result}"
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = aws_s3_bucket.msk_bucket.arn
      file_key   = "debezium.zip"
    }
  }
}

# MSK Connect Role
resource "aws_iam_role" "msk_connect_role" {
  name = "msk-connect-role-${random_string.suffix.result}"

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

resource "aws_iam_role_policy" "msk_connect_policy" {
  name = "msk-connect-policy"
  role = aws_iam_role.msk_connect_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka:*",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_msk_cluster.kafka_cluster.arn,
          aws_s3_bucket.msk_bucket.arn,
          "${aws_s3_bucket.msk_bucket.arn}/*"
        ]
      }
    ]
  })
}

# MSK Connector
resource "aws_mskconnect_connector" "debezium" {
  name = "debezium-connector-${random_string.suffix.result}"

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
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = aws_msk_cluster.kafka_cluster.bootstrap_brokers_tls

      vpc {
        security_groups = [aws_security_group.msk_sg.id]
        subnets        = aws_subnet.msk_subnet[*].id
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