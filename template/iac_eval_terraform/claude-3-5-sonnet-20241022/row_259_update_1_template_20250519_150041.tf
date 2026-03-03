provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "cluster_identifier" {
  default = "my-redshift-cluster"
}

variable "database_name" {
  default = "mydb"
}

variable "master_username" {
  default = "admin"
}

variable "master_password" {
  default = "MyPassword123!"
}

variable "notification_email" {
  default = "your-email@example.com"
}

# Create VPC Security Group for Redshift
resource "aws_security_group" "redshift_sg" {
  name        = "redshift-security-group"
  description = "Security group for Redshift cluster"

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Redshift Cluster Parameter Group
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

  parameter {
    name  = "max_concurrency_scaling_clusters"
    value = "1"
  }
}

# Create SNS Topic for notifications
resource "aws_sns_topic" "redshift_events" {
  name = "redshift-events-topic"
}

# Create SNS Topic subscription
resource "aws_sns_topic_subscription" "redshift_events_email" {
  topic_arn = aws_sns_topic.redshift_events.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# Create IAM Role for Redshift
resource "aws_iam_role" "redshift_role" {
  name = "redshift-cluster-role"

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

# Attach AWSRedshiftFullAccess policy to the role
resource "aws_iam_role_policy_attachment" "redshift_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AWSRedshiftFullAccess"
  role       = aws_iam_role.redshift_role.name
}

# Create Redshift Event Subscription
resource "aws_redshift_event_subscription" "example" {
  name          = "redshift-event-sub"
  sns_topic_arn = aws_sns_topic.redshift_events.arn
  source_type   = "cluster-parameter-group"
  severity      = "INFO"

  event_categories = [
    "configuration",
    "management",
    "monitoring",
    "security"
  ]
}

# Create Redshift Cluster
resource "aws_redshift_cluster" "example" {
  cluster_identifier  = var.cluster_identifier
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  
  # Use the custom parameter group
  cluster_parameter_group_name = aws_redshift_parameter_group.example.name
  
  # Security
  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  
  # IAM Role
  iam_roles = [aws_iam_role.redshift_role.arn]
  
  # Additional configuration
  skip_final_snapshot    = true
  publicly_accessible    = true
  port                  = 5439
  
  tags = {
    Environment = "development"
    Managed_by  = "terraform"
  }
}

# Outputs
output "redshift_cluster_endpoint" {
  value = aws_redshift_cluster.example.endpoint
}

output "redshift_cluster_id" {
  value = aws_redshift_cluster.example.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.redshift_events.arn
}