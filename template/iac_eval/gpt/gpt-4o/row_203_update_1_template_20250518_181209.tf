provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "msk_logging_role" {
  name = "MSKLoggingRole"

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

resource "aws_iam_policy" "msk_logging_policy" {
  name        = "MSKLoggingPolicy"
  description = "Policy to allow MSK to log to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "msk_logging_policy_attachment" {
  role       = aws_iam_role.msk_logging_role.name
  policy_arn = aws_iam_policy.msk_logging_policy.arn
}

resource "aws_cloudwatch_log_group" "msk_log_group" {
  name              = "/aws/msk/cluster-logs"
  retention_in_days = 7
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
    security_groups = [
      "sg-0123456789abcdef0"
    ]
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled         = true
        log_group       = aws_cloudwatch_log_group.msk_log_group.name
      }
    }
  }

  client_authentication {
    sasl {
      iam = true
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }
}