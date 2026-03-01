I'll help you create a Terraform configuration for deploying an AWS Redshift cluster with the necessary networking components. Here's what we'll create:

1. A VPC with CIDR block 10.0.0.0/16
2. Two subnets in different availability zones
3. Internet Gateway and route table for internet access
4. Redshift subnet group using the two subnets
5. IAM role for Redshift
6. Redshift cluster
7. Redshift endpoint access

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# VPC
resource "aws_vpc" "redshift_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redshift-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "redshift_igw" {
  vpc_id = aws_vpc.redshift_vpc.id

  tags = {
    Name = "redshift-igw"
  }
}

# Subnets
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "redshift-subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "redshift-subnet-2"
  }
}

# Route table
resource "aws_route_table" "redshift_rt" {
  vpc_id = aws_vpc.redshift_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.redshift_igw.id
  }

  tags = {
    Name = "redshift-rt"
  }
}

# Route table associations
resource "aws_route_table_association" "rt_assoc_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.redshift_rt.id
}

resource "aws_route_table_association" "rt_assoc_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.redshift_rt.id
}

# Redshift subnet group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "redshift-subnet-group"
  }
}

# IAM role for Redshift
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

# Attach AWSRedshiftAllCommandsFullAccess policy to the role
resource "aws_iam_role_policy_attachment" "redshift_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AWSRedshiftAllCommandsFullAccess"
  role       = aws_iam_role.redshift_role.name
}

# Redshift cluster
resource "aws_redshift_cluster" "example_cluster" {
  cluster_identifier     = "example-cluster"
  database_name         = "exampledb"
  master_username      = "admin"
  master_password      = "Password123!" # Change this in production
  node_type            = "dc2.large"
  cluster_type         = "single-node"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  iam_roles              = [aws_iam_role.redshift_role.arn]
}

# Security group for Redshift
resource "aws_security_group" "redshift_sg" {
  name        = "redshift-security-group"
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

# Redshift endpoint access
resource "aws_redshift_endpoint_access" "example" {
  cluster_identifier     = aws_redshift_cluster.example_cluster.cluster_identifier
  endpoint_name         = "example-endpoint"
  subnet_group_name    = aws_redshift_subnet_group.redshift_subnet_group.name
  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
}
</iac_template>

This Terraform configuration creates all the necessary components for a working Redshift cluster with proper networking setup. Here are some important notes:

1. The configuration uses the us-west-2 (Oregon) region
2. The VPC is created with a CIDR block of 10.0.0.0/16
3. Two subnets are created in different availability zones
4. A security group is created allowing Redshift port (5439) access
5. The Redshift cluster is single-node for demonstration purposes
6. The master password is hardcoded (should be changed in production)
7. The configuration includes necessary IAM roles and policies
8. Skip_final_snapshot is set to true (you might want to change this in production)

To use this configuration:
1. Make sure you have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

Remember to change the master password and consider enabling encryption, backup retention, and other security features for production use.