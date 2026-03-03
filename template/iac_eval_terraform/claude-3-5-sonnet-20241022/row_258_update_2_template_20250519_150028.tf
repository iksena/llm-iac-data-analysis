provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_identifier" {
  description = "The identifier for the Redshift cluster"
  type        = string
  default     = "redshift-cluster-1"
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
  default     = "Password123!"
}

# Create SNS Topic
resource "aws_sns_topic" "redshift_events" {
  name = "redshift-events-topic"
}

# Create Redshift cluster
resource "aws_redshift_cluster" "main" {
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
resource "aws_redshift_event_subscription" "main" {
  name          = "redshift-event-subscription"
  sns_topic_arn = aws_sns_topic.redshift_events.arn
  source_type   = "cluster"
  severity      = "INFO"
  source_ids    = [aws_redshift_cluster.main.id]
  
  event_categories = [
    "configuration",
    "management",
    "monitoring",
    "security"
  ]
}