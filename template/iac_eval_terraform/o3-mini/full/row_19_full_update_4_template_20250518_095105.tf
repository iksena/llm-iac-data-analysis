<iac_template>
terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

###############################
# VPC, Subnets, Internet Gateway, and Route Table
###############################

resource "aws_vpc" "eb_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "eb_vpc"
  }
}

resource "aws_internet_gateway" "eb_igw" {
  vpc_id = aws_vpc.eb_vpc.id

  tags = {
    Name = "eb_igw"
  }
}

resource "aws_subnet" "eb_subnet_public_1" {
  vpc_id                  = aws_vpc.eb_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "eb_subnet_public_1"
  }
}

resource "aws_subnet" "eb_subnet_public_2" {
  vpc_id                  = aws_vpc.eb_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "eb_subnet_public_2"
  }
}

resource "aws_route_table" "eb_route_table_public" {
  vpc_id = aws_vpc.eb_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eb_igw.id
  }

  tags = {
    Name = "eb_route_table_public"
  }
}

resource "aws_route_table_association" "assoc_public_1" {
  subnet_id      = aws_subnet.eb_subnet_public_1.id
  route_table_id = aws_route_table.eb_route_table_public.id
}

resource "aws_route_table_association" "assoc_public_2" {
  subnet_id      = aws_subnet.eb_subnet_public_2.id
  route_table_id = aws_route_table.eb_route_table_public.id
}

###############################
# Security Group for Elastic Beanstalk Environments
###############################

resource "aws_security_group" "eb_env_sg" {
  name        = "eb_env_sg"
  description = "Security group for Elastic Beanstalk environments."
  vpc_id      = aws_vpc.eb_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eb_env_sg"
  }
}

###############################
# IAM Role and Instance Profile for Elastic Beanstalk
###############################

resource "aws_iam_role" "eb_instance_role" {
  name = "eb_instance_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "eb_instance_profile"
  role = aws_iam_role.eb_instance_role.name
}

###############################
# Elastic Beanstalk Application and Environments
###############################

resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "eb_app"
  description = "Elastic Beanstalk Application for two environments"
}

# Placeholder Application Version - supply valid S3 bucket details in production.
resource "aws_elastic_beanstalk_application_version" "eb_app_version" {
  name        = "v1"
  application = aws_elastic_beanstalk_application.eb_app.name
  description = "Version v1"
  bucket      = "my-placeholder-bucket"
  key         = "app_v1.zip"
}

locals {
  public_subnets = join(",", [
    aws_subnet.eb_subnet_public_1.id,
    aws_subnet.eb_subnet_public_2.id
  ])
}

resource "aws_elastic_beanstalk_environment" "eb_env1" {
  name                = "eb_env1"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.2.5 running Python 3.8"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.eb_vpc.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = local.public_subnets
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = local.public_subnets
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_env_sg.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  tier = {
    name    = "WebServer"
    type    = "Standard"
    version = ""
  }
}

resource "aws_elastic_beanstalk_environment" "eb_env2" {
  name                = "eb_env2"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.2.5 running Python 3.8"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.eb_vpc.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = local.public_subnets
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = local.public_subnets
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_env_sg.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  tier = {
    name    = "WebServer"
    type    = "Standard"
    version = ""
  }
}

###############################
# RDS Database and Subnet Group
###############################

resource "aws_db_subnet_group" "shared_rds_subnet_group" {
  name       = "shared_rds_subnet_group"
  subnet_ids = [
    aws_subnet.eb_subnet_public_1.id,
    aws_subnet.eb_subnet_public_2.id
  ]

  tags = {
    Name = "shared_rds_subnet_group"
  }
}

resource "aws_db_instance" "shared_rds" {
  identifier             = "shared-rds"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  name                   = "shared_rds"
  username               = "admin"
  password               = "password123"  # For demonstration only. Do not use in production.
  db_subnet_group_name   = aws_db_subnet_group.shared_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.eb_env_sg.id]
  publicly_accessible    = true
  skip_final_snapshot    = true

  tags = {
    Name = "shared_rds"
  }
}
</iac_template>