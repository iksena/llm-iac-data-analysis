I'll help you create a Terraform configuration for an Amazon Aurora MySQL cluster. This configuration will include:

1. An Aurora MySQL DB cluster
2. DB subnet group for network placement
3. Security group for database access
4. Required VPC networking components
5. Initial master credentials (using variables with defaults)

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "db_master_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
}

variable "db_master_password" {
  description = "Master password for the database"
  type        = string
  default     = "mypassword123!" # Change this in production
}

# VPC Configuration
resource "aws_vpc" "aurora_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "aurora-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "aurora_igw" {
  vpc_id = aws_vpc.aurora_vpc.id

  tags = {
    Name = "aurora-igw"
  }
}

# Subnets
resource "aws_subnet" "aurora_subnet_1" {
  vpc_id            = aws_vpc.aurora_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "aurora-subnet-1"
  }
}

resource "aws_subnet" "aurora_subnet_2" {
  vpc_id            = aws_vpc.aurora_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "aurora-subnet-2"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = [aws_subnet.aurora_subnet_1.id, aws_subnet.aurora_subnet_2.id]

  tags = {
    Name = "Aurora DB subnet group"
  }
}

# Security Group
resource "aws_security_group" "aurora_sg" {
  name        = "aurora-security-group"
  description = "Security group for Aurora MySQL cluster"
  vpc_id      = aws_vpc.aurora_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aurora-sg"
  }
}

# Aurora MySQL Cluster
resource "aws_rds_cluster" "aurora_mysql_cluster" {
  cluster_identifier     = "aurora-mysql-cluster"
  engine                = "aurora-mysql"
  engine_version        = "5.7.mysql_aurora.2.11.2"
  database_name         = "mydb"
  master_username       = var.db_master_username
  master_password       = var.db_master_password
  db_subnet_group_name  = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  skip_final_snapshot   = true

  tags = {
    Name = "aurora-mysql-cluster"
  }
}

# Aurora MySQL Cluster Instance
resource "aws_rds_cluster_instance" "aurora_mysql_instance" {
  count               = 2
  identifier          = "aurora-mysql-instance-${count.index}"
  cluster_identifier  = aws_rds_cluster.aurora_mysql_cluster.id
  instance_class      = "db.t3.medium"
  engine              = aws_rds_cluster.aurora_mysql_cluster.engine
  engine_version      = aws_rds_cluster.aurora_mysql_cluster.engine_version

  tags = {
    Name = "aurora-mysql-instance-${count.index}"
  }
}

# Output the cluster endpoint
output "cluster_endpoint" {
  value = aws_rds_cluster.aurora_mysql_cluster.endpoint
}

# Output the reader endpoint
output "reader_endpoint" {
  value = aws_rds_cluster.aurora_mysql_cluster.reader_endpoint
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two subnets across different availability zones
2. A DB subnet group for the Aurora cluster
3. A security group allowing MySQL traffic (port 3306) from within the VPC
4. An Aurora MySQL cluster with two DB instances (one primary and one replica)
5. Necessary networking components (VPC, subnets, internet gateway)

The configuration includes:
- Aurora MySQL 5.7 compatible cluster
- Two db.t3.medium instances for high availability
- Basic security group rules
- Subnet group spanning two availability zones
- Output variables for cluster endpoints

Note: For production use, you should:
1. Change the default password
2. Consider using AWS Secrets Manager for credentials
3. Adjust the security group rules according to your needs
4. Review the instance class size based on your workload
5. Consider enabling backup retention and other production features
6. Consider adding encryption at rest

The configuration is ready to deploy and will create a fully functional Aurora MySQL cluster in the us-west-2 region.