provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_identifier" {
  type        = string
  description = "The Redshift cluster identifier"
  default     = "my-redshift-cluster"
}

variable "database_name" {
  type        = string
  description = "The name of the database"
  default     = "mydb"
}

variable "master_username" {
  type        = string
  description = "Master username for the Redshift cluster"
  default     = "admin"
}

variable "master_password" {
  type        = string
  description = "Master password for the Redshift cluster"
  default     = "MyP@ssw0rd123!"
  sensitive   = true
}

# SNS Topic
resource "aws_sns_topic" "redshift_events" {
  name = "redshift-parameter-group-events"
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "redshift_events" {
  arn = aws_sns_topic.redshift_events.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.redshift_events.arn
      }
    ]
  })
}

# Redshift Parameter Group
resource "aws_redshift_parameter_group" "example" {
  name   = "parameter-group-example"
  family = "redshift-1.0"

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
  cluster_identifier = var.cluster_identifier
  database_name     = var.database_name
  master_username   = var.master_username
  master_password   = var.master_password
  node_type         = "dc2.large"
  cluster_type      = "single-node"
  cluster_parameter_group_name = aws_redshift_parameter_group.example.name
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
  enabled       = true
  
  source_ids = [
    aws_redshift_parameter_group.example.name
  ]

  event_categories = [
    "configuration",
    "management",
    "monitoring",
    "security"
  ]
}