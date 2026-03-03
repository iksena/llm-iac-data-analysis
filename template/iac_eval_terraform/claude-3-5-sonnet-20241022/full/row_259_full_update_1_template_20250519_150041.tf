I'll help you create a Terraform configuration for an AWS Redshift cluster with parameter groups and event notifications. This configuration will:

1. Create a Redshift cluster parameter group with custom parameters
2. Create an SNS topic and subscription for notifications
3. Create a Redshift event subscription to monitor parameter group events
4. Create a Redshift cluster using the custom parameter group
5. Include necessary IAM roles and security groups

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates:

1. A security group for the Redshift cluster with the necessary port (5439) open
2. A custom parameter group with specific parameters for logging and SSL
3. An SNS topic and email subscription for notifications
4. An IAM role for the Redshift cluster with appropriate permissions
5. A Redshift event subscription to monitor parameter group events
6. A single-node Redshift cluster using the dc2.large node type
7. Relevant outputs for cluster endpoint, ID, and SNS topic ARN

Important notes:
- Replace the default email address in the `notification_email` variable
- The master password should be changed to something more secure in a production environment
- The security group allows access from anywhere (0.0.0.0/0) - this should be restricted in production
- The cluster is set to be publicly accessible - you might want to change this for production
- The configuration skips final snapshot - you might want to enable this for production
- All resources are created in the us-west-2 region

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Remember to confirm the SNS topic subscription via email after deployment to receive notifications.