provider "aws" {
  region = "us-west-2"
}

# Create S3 bucket for application versions
resource "aws_s3_bucket" "eb_bucket" {
  bucket = "my-eb-application-versions-bucket"
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "eb_bucket_versioning" {
  bucket = aws_s3_bucket.eb_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create IAM role for Elastic Beanstalk service
resource "aws_iam_role" "beanstalk_service_role" {
  name = "beanstalk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the service role
resource "aws_iam_role_policy_attachment" "beanstalk_service" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# Create IAM role for EC2 instances
resource "aws_iam_role" "beanstalk_ec2_role" {
  name = "beanstalk-ec2-role"

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

# Attach necessary policies to the EC2 role
resource "aws_iam_role_policy_attachment" "beanstalk_web_tier" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# Create instance profile for EC2 instances
resource "aws_iam_instance_profile" "beanstalk_ec2_profile" {
  name = "beanstalk-ec2-profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}

# Create Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "example_app" {
  name        = "example-application"
  description = "Example Elastic Beanstalk Application"

  appversion_lifecycle {
    service_role          = aws_iam_role.beanstalk_service_role.arn
    max_count            = 128
    delete_source_from_s3 = true
  }
}

# Variables with default values
variable "environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  type        = string
  default     = "example-environment"
}

variable "solution_stack_name" {
  description = "Solution stack name for the Elastic Beanstalk environment"
  type        = string
  default     = "64bit Amazon Linux 2 v5.6.4 running Node.js 18"
}

# Create Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "example_environment" {
  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.example_app.name
  solution_stack_name = var.solution_stack_name
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_ec2_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service_role.name
  }
}