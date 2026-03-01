provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "msk_role" {
  name = "MSKClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kafka.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "msk_policy" {
  name        = "MSKClusterPolicy"
  description = "Policy for MSK Cluster to allow monitoring"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "msk_policy_attachment" {
  role       = aws_iam_role.msk_role.name
  policy_arn = aws_iam_policy.msk_policy.arn
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

  monitoring {
    enhanced_monitoring = "PER_BROKER"
    jmx_exporter {
      enabled_in_broker = true
    }
    node_exporter {
      enabled_in_broker = true
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = "msk-cluster-logs"
      }
    }
  }
}