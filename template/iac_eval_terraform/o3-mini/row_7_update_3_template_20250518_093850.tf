terraform {
  required_version = ">= 1.0"

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

# Create an IAM Role for EC2 instances with the appropriate trust policy.
resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the AWS-provided Elastic Beanstalk Web Tier policy to the IAM role.
resource "aws_iam_role_policy_attachment" "eb_ec2_role_attachment" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkWebTier"
}

# Create the IAM Instance Profile for the Elastic Beanstalk environment.
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Define the Elastic Beanstalk Application.
resource "aws_elastic_beanstalk_application" "my_api_app" {
  name        = "my_api_app"
  description = "Elastic Beanstalk Application for API"
}

# Create the Elastic Beanstalk Environment with autoscaling settings based on CPU utilization.
resource "aws_elastic_beanstalk_environment" "my_api_env" {
  name                = "my_api_env"
  application         = aws_elastic_beanstalk_application.my_api_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.12 running Python 3.8"

  # Pass the instance profile to the environment.
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  # Configure autoscaling group size.
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }

  # Configure scaling triggers based on CPU utilization.
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "70"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "20"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperBreachScaleIncrement"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerBreachScaleIncrement"
    value     = "-1"
  }
}