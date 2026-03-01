tags.

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
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
  description = "Allocated storage for the DB instance"
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

# IAM Role for Elastic Beanstalk EC2 instances
resource "aws_iam_role" "eb_instance_role" {
  name = "ec2_eb_profile1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Attach a managed policy for basic EC2 functionalities
resource "aws_iam_role_policy_attachment" "eb_instance_policy_attach" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# Create instance profile for Elastic Beanstalk
resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "ec2_eb_profile1"
  role = aws_iam_role.eb_instance_role.name
}

# RDS Database
resource "aws_db_instance" "my_db" {
  identifier              = "my-db-instance"
  allocated_storage       = var.db_allocated_storage
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  name                    = "my_db"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = true
  multi_az                = false

  # For simplicity, using default VPC and its settings.
  # In production, consider creating a subnet group and proper VPC configuration.
}

# Take a snapshot of the database prior to deployment (this resource creation depends on the RDS instance)
resource "aws_db_snapshot" "my_db_snapshot" {
  db_instance_identifier = aws_db_instance.my_db.id
  snapshot_identifier    = "my_db_snapshot"
  depends_on             = [aws_db_instance.my_db]
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "blue-green-app"
  description = "Application for blue/green deployment with associated RDS database"
}

# Elastic Beanstalk Environment option settings common to both environments.
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
      value     = aws_db_instance.my_db.name
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

# Blue Environment
resource "aws_elastic_beanstalk_environment" "blue_env" {
  name                = "blue-environment"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.7 running Node.js 14"  # example platform

  setting {
    for_each = { for s in local.common_settings : s.name => s }
    namespace = each.value.namespace
    name      = each.value.name
    value     = each.value.value
  }
}

# Green Environment
resource "aws_elastic_beanstalk_environment" "green_env" {
  name                = "green-environment"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.7 running Node.js 14"  # example platform

  setting {
    for_each = { for s in local.common_settings : s.name => s }
    namespace = each.value.namespace
    name      = each.value.name
    value     = each.value.value
  }
}

output "rds_endpoint" {
  description = "Endpoint of the RDS database"
  value       = aws_db_instance.my_db.address
}

output "blue_environment_url" {
  description = "URL of the blue environment"
  value       = aws_elastic_beanstalk_environment.blue_env.endpoint_url
}

output "green_environment_url" {
  description = "URL of the green environment"
  value       = aws_elastic_beanstalk_environment.green_env.endpoint_url
}