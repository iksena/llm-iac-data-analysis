provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "cluster_identifier" {
  description = "The identifier for the Redshift cluster"
  default     = "redshift-cluster-1"
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

# Create SNS Topic
resource "aws_sns_topic" "redshift_events" {
  name = "redshift-events-topic"
}

# Create IAM role for Redshift event subscription
resource "aws_iam_role" "redshift_event_role" {
  name = "redshift-event-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.redshift.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM role policy for SNS publish
resource "aws_iam_role_policy" "redshift_event_policy" {
  name = "redshift-event-policy"
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

# Create Redshift cluster
resource "aws_redshift_cluster" "cluster" {
  cluster_identifier  = var.cluster_identifier
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  skip_final_snapshot = true

  tags = {
    Environment = "production"
  }
}

# Create Redshift event subscription
resource "aws_redshift_event_subscription" "cluster_events" {
  name          = "redshift-event-sub"
  sns_topic_arn = aws_sns_topic.redshift_events.arn
  source_type   = "cluster"
  severity      = "INFO"
  
  source_ids = [
    aws_redshift_cluster.cluster.id
  ]

  event_categories = [
    "configuration",
    "management",
    "monitoring",
    "security"
  ]

  depends_on = [
    aws_redshift_cluster.cluster,
    aws_sns_topic.redshift_events,
    aws_iam_role.redshift_event_role
  ]
}