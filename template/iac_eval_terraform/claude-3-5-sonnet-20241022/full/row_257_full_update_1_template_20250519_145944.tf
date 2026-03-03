I'll help you create a Terraform configuration to deploy an AWS Redshift cluster with event notifications. This configuration will:

1. Create a Redshift cluster with basic configuration
2. Set up an SNS topic for notifications
3. Create necessary IAM roles and policies
4. Configure Redshift event subscriptions to send notifications to the SNS topic

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "cluster_identifier" {
  description = "The Redshift cluster identifier"
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
  default     = "Admin123456789"
}

# Create SNS Topic
resource "aws_sns_topic" "redshift_events" {
  name = "redshift-events"
}

# IAM Role for Redshift
resource "aws_iam_role" "redshift_role" {
  name = "redshift_role"

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

# IAM Role Policy for Redshift
resource "aws_iam_role_policy" "redshift_policy" {
  name = "redshift_policy"
  role = aws_iam_role.redshift_role.id

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

# Create Redshift Subnet Group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.redshift_subnet.id]
}

# Create VPC
resource "aws_vpc" "redshift_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redshift-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "redshift_subnet" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "redshift-subnet"
  }
}

# Create Redshift Cluster
resource "aws_redshift_cluster" "cluster" {
  cluster_identifier  = var.cluster_identifier
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  skip_final_snapshot = true

  iam_roles = [aws_iam_role.redshift_role.arn]
  
  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
}

# Create Security Group
resource "aws_security_group" "redshift_sg" {
  name        = "redshift-sg"
  description = "Security group for Redshift cluster"
  vpc_id      = aws_vpc.redshift_vpc.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Redshift Event Subscription
resource "aws_redshift_event_subscription" "cluster_events" {
  name             = "redshift-event-sub"
  sns_topic_arn    = aws_sns_topic.redshift_events.arn
  source_type      = "cluster"
  source_ids       = [aws_redshift_cluster.cluster.id]
  severity         = "INFO"
  event_categories = [
    "configuration",
    "management",
    "monitoring",
    "security"
  ]
}

# Internet Gateway
resource "aws_internet_gateway" "redshift_igw" {
  vpc_id = aws_vpc.redshift_vpc.id

  tags = {
    Name = "redshift-igw"
  }
}

# Route Table
resource "aws_route_table" "redshift_route_table" {
  vpc_id = aws_vpc.redshift_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.redshift_igw.id
  }

  tags = {
    Name = "redshift-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "redshift_route_association" {
  subnet_id      = aws_subnet.redshift_subnet.id
  route_table_id = aws_route_table.redshift_route_table.id
}
</iac_template>

This Terraform configuration creates:

1. A VPC with necessary networking components (subnet, internet gateway, route table)
2. A security group for the Redshift cluster
3. An SNS topic for event notifications
4. IAM roles and policies for Redshift to publish to SNS
5. A Redshift cluster with basic configuration
6. An event subscription that monitors the cluster and sends notifications to the SNS topic

The configuration includes:
- A single-node Redshift cluster
- Basic network security with a dedicated VPC and security group
- Event monitoring for configuration, management, monitoring, and security events
- All necessary IAM roles and permissions
- Default variables for cluster configuration

To deploy this infrastructure:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: Make sure to:
- Change the default password in the variables
- Adjust the CIDR blocks and security group rules according to your security requirements
- Consider using AWS Secrets Manager or AWS Systems Manager Parameter Store for sensitive values in production
- Review the node type and adjust according to your needs
- Subscribe to the SNS topic after creation to receive notifications