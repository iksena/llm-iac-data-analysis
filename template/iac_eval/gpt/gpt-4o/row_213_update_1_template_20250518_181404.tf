provider "aws" {
  region = "us-east-1"
}

resource "aws_msk_cluster" "example" {
  cluster_name           = "example-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = "kafka.m5.large"
    client_subnets = [
      "subnet-0123456789abcdef0",
      "subnet-0123456789abcdef1",
      "subnet-0123456789abcdef2"
    ]
    security_groups = ["sg-0123456789abcdef0"]
  }
}

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

resource "aws_iam_policy" "msk_connect_policy" {
  name        = "msk-connect-policy"
  description = "Policy for MSK Connect to access MSK and S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeCluster",
          "kafka-cluster:DescribeClusterOperation",
          "kafka-cluster:DescribeNode",
          "kafka-cluster:GetBootstrapBrokers"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::my-debezium-bucket",
          "arn:aws:s3:::my-debezium-bucket/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.msk_connect_role.name
  policy_arn = aws_iam_policy.msk_connect_policy.arn
}

resource "aws_mskconnect_custom_plugin" "debezium_plugin" {
  name        = "debezium-plugin"
  content_type = "ZIP"
  location {
    s3_bucket = "my-debezium-bucket"
    s3_key    = "debezium.zip"
  }
}

resource "aws_mskconnect_connector" "example_connector" {
  name          = "example-connector"
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
    "database.server.name" = "dbserver1"
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
      arn = aws_mskconnect_custom_plugin.debezium_plugin.arn
    }
  }
  service_execution_role_arn = aws_iam_role.msk_connect_role.arn
}