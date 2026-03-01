provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_identifier" {
  description = "The Redshift cluster identifier"
  default     = "my-redshift-cluster"
}

variable "database_name" {
  description = "The name of the database"
  default     = "mydb"
}

variable "master_username" {
  description = "Master username for the Redshift cluster"
  default     = "admin"
}

variable "master_password" {
  description = "Master password for the Redshift cluster"
  default     = "MyP@ssw0rd123!"
}

# SNS Topic
resource "aws_sns_topic" "redshift_events" {
  name = "redshift-parameter-group-events"
}

# IAM Role for Redshift Event Subscription
resource "aws_iam_role" "redshift_event_role" {
  name = "redshift-event-subscription-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Redshift Event Subscription
resource "aws_iam_role_policy" "redshift_event_policy" {
  name = "redshift-event-subscription-policy"
  role = aws_iam_role.redshift_event_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          aws_sns_topic.redshift_events.arn
        ]
      }
    ]
  })
}

# Redshift Parameter Group
resource "aws_redshift_parameter_group" "example" {
  name        = "parameter-group-example"
  family      = "redshift-1.0"
  description = "Example Redshift parameter group"

  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }

  parameter {
    name  = "require_ssl"
    value = "true"
  }
}

# Redshift Cluster
resource "aws_redshift_cluster" "example" {
  cluster_identifier  = var.cluster_identifier
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  
  parameter_group_name = aws_redshift_parameter_group.example.name
  
  skip_final_snapshot = true
  
  tags = {
    Environment = "development"
  }
}

# Redshift Event Subscription
resource "aws_redshift_event_subscription" "example" {
  name          = "redshift-parameter-group-subscription"
  sns_topic_arn = aws_sns_topic.redshift_events.arn
  source_type   = "parameter-group"
  severity      = "INFO"
  
  source_ids = [
    aws_redshift_parameter_group.example.name
  ]

  event_categories = [
    "configuration",
    "management",
    "monitoring",
    "security"
  ]

  depends_on = [
    aws_iam_role_policy.redshift_event_policy
  ]
}