provider "aws" {
  region = "us-west-2"
}

# Variables
variable "db_password" {
  description = "Database password"
  type        = string
  default     = "mydbpassword123!"
}

# Create VPC (simplified for this example)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "eb-vpc"
  }
}

# Create subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "eb-subnet"
  }
}

# Create IAM role for Elastic Beanstalk
resource "aws_iam_role" "eb_role" {
  name = "eb_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the role
resource "aws_iam_role_policy_attachment" "eb_policy" {
  role       = aws_iam_role.eb_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# Create instance profile
resource "aws_iam_instance_profile" "ec2_eb_profile1" {
  name = "ec2_eb_profile1"
  role = aws_iam_role.eb_role.name
}

# Create RDS instance
resource "aws_db_instance" "my_db" {
  identifier           = "my-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  name                = "my_db"
  username            = "admin"
  password            = var.db_password
  skip_final_snapshot = false
  final_snapshot_identifier = "my-db-final-snapshot"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
}

# Create DB snapshot
resource "aws_db_snapshot" "my_db_snapshot" {
  db_instance_identifier = aws_db_instance.my_db.id
  db_snapshot_identifier = "my-db-snapshot-${formatdate("YYYYMMDDhhmmss", timestamp())}"
}

# Create Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "app" {
  name        = "my-app"
  description = "My Application"
}

# Create Blue environment
resource "aws_elastic_beanstalk_environment" "blue" {
  name                = "my-app-blue"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.6.1 running Node.js 18"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2_eb_profile1.name
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.main.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = aws_subnet.main.id
  }
}

# Create Green environment
resource "aws_elastic_beanstalk_environment" "green" {
  name                = "my-app-green"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.6.1 running Node.js 18"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2_eb_profile1.name
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.main.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = aws_subnet.main.id
  }
}

# Create security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
}

# Create DB subnet group
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.main.id]
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}