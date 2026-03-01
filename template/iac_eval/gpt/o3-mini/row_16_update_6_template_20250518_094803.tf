terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "us-east-1"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  default     = "ChangeMe123!"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the DB instance (in GB)"
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t2.micro"
}

variable "db_engine" {
  description = "Database engine name"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "5.7"
}

# IAM Role for Elastic Beanstalk EC2 instances with instance profile "ec2_eb_profile1"
resource "aws_iam_role" "eb_instance_role" {
  name = "ec2_eb_profile1"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach a managed policy for basic EC2 functionalities
resource "aws_iam_role_policy_attachment" "eb_instance_policy_attach" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# Create instance profile for Elastic Beanstalk using the above IAM role
resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "ec2_eb_profile1"
  role = aws_iam_role.eb_instance_role.name
}

# RDS Database instance with name "my_db"
resource "aws_db_instance" "my_db" {
  identifier            = "my-db-instance"
  allocated_storage     = var.db_allocated_storage
  engine                = var.db_engine
  engine_version        = var.db_engine_version
  instance_class        = var.db_instance_class
  name                  = "my_db"
  username              = var.db_username
  password              = var.db_password
  skip_final_snapshot   = true
  publicly_accessible   = true
  multi_az              = false
}

# Take a snapshot of the database prior to any deployment changes
resource "aws_db_snapshot" "my_db_snapshot" {
  db_instance_identifier = aws_db_instance.my_db.id
  db_snapshot_identifier = "my_db_snapshot"
  depends_on             = [aws_db_instance.my_db]
}

# Elastic Beanstalk Application for Blue/Green deployment
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "blue-green-app"
  description = "Application for blue/green deployment associated with an RDS database"
}

# Local common settings to be applied in both environments
locals {
  common_settings = [
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "IamInstanceProfile"
      value     = aws_iam_instance_profile.eb_instance_profile.name
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = "DB_HOST"
      value     = aws_db_instance.my_db.address
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = "DB_NAME"
      value     = "my_db"
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = "DB_USERNAME"
      value     = var.db_username
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = "DB_PASSWORD"
      value     = var.db_password
    }
  ]
}

# Blue Environment for deployment
resource "aws_elastic_beanstalk_environment" "blue_env" {
  name                = "blue-environment"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.7 running Node.js 14"  # Update as needed

  dynamic "setting" {
    for_each = local.common_settings
    content {
      namespace = setting.value.namespace
      name      = setting.value.name
      value     = setting.value.value
    }
  }
}

# Green Environment for deployment
resource "aws_elastic_beanstalk_environment" "green_env" {
  name                = "green-environment"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.7 running Node.js 14"  # Update as needed

  dynamic "setting" {
    for_each = local.common_settings
    content {
      namespace = setting.value.namespace
      name      = setting.value.name
      value     = setting.value.value
    }
  }
}

output "rds_endpoint" {
  description = "Endpoint of the RDS database"
  value       = aws_db_instance.my_db.address
}

output "blue_environment_url" {
  description = "URL of the blue Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.blue_env.endpoint_url
}

output "green_environment_url" {
  description = "URL of the green Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.green_env.endpoint_url
}