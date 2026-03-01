provider "aws" {
  region = "us-west-2"
}

# Define local values for RDS credentials
locals {
  rds_username = "admin"
  rds_password = "password123"
}

# IAM role for Elastic Beanstalk EC2 instances
resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"
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

# Instance profile with the fixed name "eb_ec2_profile"
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "my-eb-app"
  description = "Elastic Beanstalk application with autoscaling and RDS integration"
}

# RDS MySQL database instance named "my_db1"
resource "aws_db_instance" "my_db1" {
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  name                    = "my_db1"
  username                = local.rds_username
  password                = local.rds_password
  identifier              = "my-db1"
  skip_final_snapshot     = true
  publicly_accessible     = true
  vpc_security_group_ids  = [data.aws_security_group.default.id]
}

# Data source to reference the default security group in the default VPC
data "aws_security_group" "default" {
  name = "default"
}

# Elastic Beanstalk environment with autoscaling and RDS connection settings
resource "aws_elastic_beanstalk_environment" "eb_env" {
  name                = "my-eb-environment"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = var.solution_stack

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MetricName"
    value     = "CPUUtilization"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "80"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "20"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = "Average"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  # Environment properties to connect to the RDS database
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_HOSTNAME"
    value     = aws_db_instance.my_db1.address
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PORT"
    value     = tostring(aws_db_instance.my_db1.port)
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_DB_NAME"
    value     = aws_db_instance.my_db1.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_USERNAME"
    value     = local.rds_username
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PASSWORD"
    value     = local.rds_password
  }

  depends_on = [aws_db_instance.my_db1]
}

# Variable for Elastic Beanstalk solution stack with a default value.
variable "solution_stack" {
  description = "The solution stack name for Elastic Beanstalk."
  type        = string
  default     = "64bit Amazon Linux 2 v3.4.8 running Python 3.8"
}