I'll help you create a Terraform configuration that sets up an AWS Redshift cluster with an event subscription that sends events to an SNS topic. Here's what the configuration will include:

1. An AWS Redshift cluster with basic configuration
2. An SNS topic to receive Redshift events
3. An IAM role for Redshift event subscription
4. A Redshift event subscription that monitors the cluster and sends notifications to the SNS topic

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-west-2 region
2. Variables with default values for the Redshift cluster configuration
3. An SNS topic that will receive Redshift events
4. An IAM role and policy that allows Redshift to publish events to the SNS topic
5. A single-node Redshift cluster with basic configuration
6. A Redshift event subscription that monitors the cluster and sends notifications to the SNS topic

The event subscription is configured to monitor all important event categories (configuration, management, monitoring, and security) at the INFO severity level.

Note: 
- The configuration uses default values for simplicity, but in a production environment, you should change the password and other sensitive values.
- The Redshift cluster is configured as single-node for demonstration purposes. For production use, you might want to use a multi-node cluster.
- The configuration skips the final snapshot (skip_final_snapshot = true) for easier cleanup, but in production, you might want to keep this enabled.