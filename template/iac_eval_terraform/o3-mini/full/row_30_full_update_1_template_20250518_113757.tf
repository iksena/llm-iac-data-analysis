Description:
This Terraform program provisions an AWS Elastic Beanstalk application to deploy a web application. It creates an S3 bucket to store a sample application source bundle, uploads a dummy web application archive (assumed to be available locally as "webapp.zip"), creates an Elastic Beanstalk application and an application version referencing the source bundle, and then creates an Elastic Beanstalk environment using that version with auto scaling configured (minimum one instance, maximum four instances). An IAM role and instance profile are created for the EC2 instances used by Elastic Beanstalk. The AWS provider is configured for the us-east-1 region.

<iac_template>
terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of the Elastic Beanstalk application"
  type        = string
  default     = "my-web-app"
}

variable "environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  type        = string
  default     = "my-web-app-env"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to store the application bundle"
  type        = string
  default     = "my-web-app-bucket-example-terraform-unique"
}

variable "app_version_label" {
  description = "Application version label for Elastic Beanstalk"
  type        = string
  default     = "v1"
}

# IAM Role for Elastic Beanstalk EC2 instance
resource "aws_iam_role" "beanstalk_ec2_role" {
  name               = "beanstalk_ec2_role"
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

# Attach AWS managed policy for Beanstalk EC2 instances
resource "aws_iam_role_policy_attachment" "beanstalk_ec2_policy_attach" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# Create IAM Instance Profile for Elastic Beanstalk EC2 instances
resource "aws_iam_instance_profile" "beanstalk_instance_profile" {
  name = "beanstalk_instance_profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}

# Create S3 bucket to store application source bundle
resource "aws_s3_bucket" "app_bucket" {
  bucket = var.s3_bucket_name

  acl    = "private"

  tags = {
    Name = "WebAppBucket"
  }
}

# Upload the sample web application zip file to S3.
# Ensure that a file named "webapp.zip" exists in the working directory when applying.
resource "aws_s3_bucket_object" "app_bundle" {
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "webapp.zip"
  source = "webapp.zip"
  etag   = filemd5("webapp.zip")
}

# Create the Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "web_app" {
  name        = var.app_name
  description = "Elastic Beanstalk application for a scalable web app"
}

# Create an application version for Elastic Beanstalk referencing the S3 bundle
resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = var.app_version_label
  application = aws_elastic_beanstalk_application.web_app.name

  bucket = aws_s3_bucket.app_bucket.bucket
  key    = aws_s3_bucket_object.app_bundle.key

  lifecycle {
    # Prevent recreation unless the version label is changed.
    ignore_changes = [bucket, key]
  }
}

# Create the Elastic Beanstalk Environment with Auto Scaling and Instance Profile
resource "aws_elastic_beanstalk_environment" "web_app_env" {
  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.web_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.6 running Node.js 14"   # Example supported platform; adjust as necessary.
  version_label       = aws_elastic_beanstalk_application_version.app_version.name

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

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }
}
</iac_template>