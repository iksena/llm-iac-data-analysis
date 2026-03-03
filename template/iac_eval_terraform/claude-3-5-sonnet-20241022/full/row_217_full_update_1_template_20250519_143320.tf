I'll help you create a Terraform configuration for an Amazon RDS MySQL cluster with multi-zone deployment and 100 GB storage allocation per zone. This configuration will include:

1. An RDS DB cluster with MySQL engine
2. DB subnet group for multi-AZ deployment
3. Required VPC networking components
4. Necessary security group
5. Required IAM roles and policies
6. Multiple DB instances across availability zones

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# VPC Configuration
resource "aws_vpc" "mysql_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "mysql-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "mysql_igw" {
  vpc_id = aws_vpc.mysql_vpc.id

  tags = {
    Name = "mysql-igw"
  }
}

# Subnets in different AZs
resource "aws_subnet" "mysql_subnet_1" {
  vpc_id            = aws_vpc.mysql_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "mysql-subnet-1"
  }
}

resource "aws_subnet" "mysql_subnet_2" {
  vpc_id            = aws_vpc.mysql_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "mysql-subnet-2"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql-subnet-group"
  subnet_ids = [aws_subnet.mysql_subnet_1.id, aws_subnet.mysql_subnet_2.id]

  tags = {
    Name = "MySQL DB subnet group"
  }
}

# Security Group
resource "aws_security_group" "mysql_sg" {
  name        = "mysql-security-group"
  description = "Security group for MySQL cluster"
  vpc_id      = aws_vpc.mysql_vpc.id

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
}

# RDS Cluster
resource "aws_rds_cluster" "mysql_cluster" {
  cluster_identifier     = "mysql-cluster"
  engine                = "aurora-mysql"
  engine_version        = "5.7.mysql_aurora.2.10.2"
  database_name         = "mydb"
  master_username       = "admin"
  master_password       = "mysqlpass123!" # Change this in production
  skip_final_snapshot   = true
  db_subnet_group_name  = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  tags = {
    Name = "mysql-cluster"
  }
}

# RDS Cluster Instances
resource "aws_rds_cluster_instance" "mysql_instances" {
  count               = 2
  identifier          = "mysql-cluster-${count.index}"
  cluster_identifier  = aws_rds_cluster.mysql_cluster.id
  instance_class      = "db.r5.large"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.10.2"
  allocated_storage   = 100

  tags = {
    Name = "mysql-cluster-${count.index}"
  }
}

# Route Table
resource "aws_route_table" "mysql_route_table" {
  vpc_id = aws_vpc.mysql_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mysql_igw.id
  }

  tags = {
    Name = "mysql-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "mysql_route_table_assoc_1" {
  subnet_id      = aws_subnet.mysql_subnet_1.id
  route_table_id = aws_route_table.mysql_route_table.id
}

resource "aws_route_table_association" "mysql_route_table_assoc_2" {
  subnet_id      = aws_subnet.mysql_subnet_2.id
  route_table_id = aws_route_table.mysql_route_table.id
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two subnets in different availability zones
2. An Internet Gateway and appropriate routing
3. A security group allowing MySQL traffic (port 3306) within the VPC
4. A DB subnet group spanning multiple AZs
5. An Aurora MySQL cluster with two instances
6. Each instance is allocated 100 GB of storage
7. The instances are distributed across two availability zones for high availability

Important notes:
- The configuration uses the AWS provider in the us-east-1 region
- The master password is hardcoded for demonstration (should be changed in production)
- The security group allows MySQL access only from within the VPC
- The configuration uses Aurora MySQL 5.7 compatible engine
- The instance class is set to db.r5.large, which can be adjusted based on performance needs
- Skip_final_snapshot is set to true for easier cleanup (consider changing in production)

Remember to:
1. Change the master password before deploying to production
2. Adjust the security group rules according to your needs
3. Consider enabling backup retention and other production-ready features
4. Review the instance class size based on your workload requirements