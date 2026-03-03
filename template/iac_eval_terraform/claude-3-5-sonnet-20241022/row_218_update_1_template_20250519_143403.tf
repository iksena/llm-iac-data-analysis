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

# Subnets
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

resource "aws_subnet" "mysql_subnet_3" {
  vpc_id            = aws_vpc.mysql_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "mysql-subnet-3"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql-subnet-group"
  subnet_ids = [aws_subnet.mysql_subnet_1.id, aws_subnet.mysql_subnet_2.id, aws_subnet.mysql_subnet_3.id]

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

  tags = {
    Name = "mysql-sg"
  }
}

# DB Parameter Group
resource "aws_db_parameter_group" "mysql_parameter_group" {
  family = "mysql8.0"
  name   = "mysql-parameter-group"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

# MySQL DB Instances
resource "aws_db_instance" "mysql_instance_1" {
  identifier           = "mysql-instance-1"
  allocated_storage    = 100
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.medium"
  username            = "admin"
  password            = "mysqlpassword123!" # Change this in production
  parameter_group_name = aws_db_parameter_group.mysql_parameter_group.name
  db_subnet_group_name = aws_db_subnet_group.mysql_subnet_group.name
  availability_zone    = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  skip_final_snapshot  = true

  tags = {
    Name = "mysql-instance-1"
  }
}

resource "aws_db_instance" "mysql_instance_2" {
  identifier           = "mysql-instance-2"
  allocated_storage    = 100
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.medium"
  username            = "admin"
  password            = "mysqlpassword123!" # Change this in production
  parameter_group_name = aws_db_parameter_group.mysql_parameter_group.name
  db_subnet_group_name = aws_db_subnet_group.mysql_subnet_group.name
  availability_zone    = "us-east-1b"
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  skip_final_snapshot  = true

  tags = {
    Name = "mysql-instance-2"
  }
}

resource "aws_db_instance" "mysql_instance_3" {
  identifier           = "mysql-instance-3"
  allocated_storage    = 100
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.medium"
  username            = "admin"
  password            = "mysqlpassword123!" # Change this in production
  parameter_group_name = aws_db_parameter_group.mysql_parameter_group.name
  db_subnet_group_name = aws_db_subnet_group.mysql_subnet_group.name
  availability_zone    = "us-east-1c"
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  skip_final_snapshot  = true

  tags = {
    Name = "mysql-instance-3"
  }
}