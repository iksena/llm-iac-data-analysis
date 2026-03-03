I'll help you create a Terraform configuration to deploy an Amazon Redshift cluster with a single node. This configuration will include:

1. An AWS provider configuration
2. A Redshift cluster with a single node
3. Required IAM role and policy for Redshift
4. Necessary security group for Redshift access
5. Required variables with default values

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_identifier" {
  description = "The name of the Redshift cluster"
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
  default     = "Admin123456789"
}

# Create security group for Redshift
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

# Create IAM role for Redshift
resource "aws_iam_role" "redshift_role" {
  name = "redshift-role"

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

# Attach AWSRedshiftServiceRole policy to the IAM role
resource "aws_iam_role_policy_attachment" "redshift_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSRedshiftServiceRole"
  role       = aws_iam_role.redshift_role.name
}

# Create Redshift cluster
resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier  = var.cluster_identifier
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  number_of_nodes    = 1

  skip_final_snapshot = true
  
  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  iam_roles             = [aws_iam_role.redshift_role.arn]

  tags = {
    Environment = "development"
    Name        = "single-node-redshift-cluster"
  }
}
</iac_template>

This Terraform configuration creates:
1. A single-node Redshift cluster using the dc2.large node type
2. A security group that allows incoming traffic on port 5439 (Redshift's default port)
3. An IAM role with the necessary permissions for Redshift
4. All required variables with default values

Important notes:
- The configuration uses the us-west-2 (Oregon) region
- The master password is set as a default value in the variable (in production, you should never store passwords in plain text)
- The security group allows access from any IP (0.0.0.0/0) - in production, you should restrict this to specific IP ranges
- skip_final_snapshot is set to true to make cluster deletion easier (in production, you might want to set this to false)
- The cluster uses dc2.large node type, which is a good starting point for development purposes

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Remember to destroy the resources when they're no longer needed using `terraform destroy` to avoid unnecessary costs.