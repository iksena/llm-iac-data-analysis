provider "aws" {
  region = "us-east-1"
}

resource "aws_msk_cluster" "example" {
  cluster_name           = "example-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = "kafka.m5.large"
    client_subnets = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1", "subnet-0123456789abcdef2"]
    security_groups = ["sg-0123456789abcdef0"]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/your-kms-key-id"
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
        log_group = aws_cloudwatch_log_group.example.name
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "example" {
  name = "/aws/msk/example-cluster"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-msk-bucket"
  acl    = "private"
}

resource "aws_kinesis_firehose_delivery_stream" "example" {
  name        = "example-firehose"
  destination = "s3"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.example.arn
    buffer_size        = 5
    buffer_interval    = 300
    compression_format = "GZIP"
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_delivery_role"

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
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.example.arn}/*"
      }
    ]
  })
}

resource "aws_mskconnect_custom_plugin" "debezium" {
  name        = "debezium-plugin"
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = aws_s3_bucket.example.arn
      file_key   = "debezium.zip"
    }
  }
}

resource "aws_mskconnect_connector" "example_connector" {
  name               = "example-connector"
  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = aws_msk_cluster.example.bootstrap_brokers
      vpc {
        security_groups = ["sg-0123456789abcdef0"]
      }
    }
  }
  connector_configuration = {
    "connector.class" = "io.debezium.connector.mysql.MySqlConnector"
    "tasks.max"       = "1"
    "database.hostname" = "your-database-hostname"
    "database.port"     = "3306"
    "database.user"     = "your-database-user"
    "database.password" = "your-database-password"
    "database.server.id" = "184054"
    "database.server.name" = "fullfillment"
    "database.whitelist" = "inventory"
    "database.history.kafka.bootstrap.servers" = aws_msk_cluster.example.bootstrap_brokers
    "database.history.kafka.topic" = "schema-changes.inventory"
  }
  capacity {
    auto_scaling {
      max_worker_count = 10
      mcu_count        = 1
      min_worker_count = 1
      scale_in_policy {
        cpu_utilization_percentage = 20
      }
      scale_out_policy {
        cpu_utilization_percentage = 80
      }
    }
  }
  plugin {
    custom_plugin {
      custom_plugin_arn = aws_mskconnect_custom_plugin.debezium.arn
      revision          = 1
    }
  }
}