provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_identifier" {
  description = "The Redshift cluster identifier"
  type        = string
  default     = "my-redshift-cluster"
}

variable "database_name" {
  description = "The name of the database"
  type        = string
  default     = "mydb"
}

variable "master_username" {
  description = "Master username for the Redshift cluster"
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "Master password for the Redshift cluster"
  type        = string
  default     = "MyP@ssw0rd123!"
}

# SNS Topic
resource "aws_sns_topic" "redshift_events" {
  name = "redshift-parameter-group-events"
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

# SNS Topic Policy
resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.redshift_events.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowRedshiftEvents"
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

# Redshift Event Subscription
resource "aws_redshift_event_subscription" "example" {
  name          = "redshift-parameter-group-subscription"
  sns_topic_arn = aws_sns_topic.redshift_events.arn
  source_type   = "parameter-group"
  severity      = "INFO"
  
  source_ids = [
    aws_redshift_parameter_group.example.id
  ]

  event_categories = [
    "configuration",
    "management",
    "monitoring",
    "security"
  ]
}