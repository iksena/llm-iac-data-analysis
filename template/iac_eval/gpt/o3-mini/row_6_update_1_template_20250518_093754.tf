provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources."
  default     = "us-east-1"
}

resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
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

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

resource "aws_elastic_beanstalk_application" "my_application" {
  name        = "my_application"
  description = "Elastic Beanstalk Application for my_application."
}

resource "aws_elastic_beanstalk_environment" "my_environment" {
  name                = "my-environment"
  application         = aws_elastic_beanstalk_application.my_application.name
  solution_stack_name = "64bit Amazon Linux 2 running Python 3.8"
  
  setting {
    namespace  = "aws:autoscaling:launchconfiguration"
    name       = "IamInstanceProfile"
    value      = aws_iam_instance_profile.eb_ec2_profile.name
  }
}

output "application_name" {
  value = aws_elastic_beanstalk_application.my_application.name
}

output "environment_name" {
  value = aws_elastic_beanstalk_environment.my_environment.name
}