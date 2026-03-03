Below is an improved version of the Terraform configuration addressing the syntax issues. We keep the overall architecture – provisioning app bucket, uploading an application bundle, creating IAM roles, and creating an Elastic Beanstalk-based web application – while ensuring all blocks are valid and all references are declared. Ensure that a file named "webapp.zip" exists in your working directory when running Terraform.

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
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of the Elastic Beanstalk application."
  type        = string
  default     = "my-web-app"
}

variable "environment_name" {
  description = "Name of the Elastic Beanstalk environment."
  type        = string
  default     = "my-web-app-env"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to store the application bundle."
  type        = string
  default     = "my-web-app-bucket-example-terraform-unique"
}

variable "app_version_label" {
  description = "Application version label for Elastic Beanstalk."
  type        = string
  default     = "v1"
}

#####################
# IAM RESOURCES
#####################

# IAM Role for Elastic Beanstalk EC2 instance
resource "aws_iam_role" "beanstalk_ec2_role" {
  name = "beanstalk_ec2_role"

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

#####################
# S3 BUCKET & APPLICATION BUNDLE
#####################

# Create S3 bucket to store application source bundle.
resource "aws_s3_bucket" "app_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  tags = {
    Name = "WebAppBucket"
  }
}

# Upload the application bundle (Make sure "webapp.zip" exists in your working directory).
resource "aws_s3_bucket_object" "app_bundle" {
  bucket = aws_s3_bucket.app_bucket.id
  key    = "webapp.zip"
  source = "webapp.zip"
  etag   = filemd5("webapp.zip")
}

#####################
# ELASTIC BEANSTALK RESOURCES
#####################

# Create the Elastic Beanstalk Application.
resource "aws_elastic_beanstalk_application" "web_app" {
  name        = var.app_name
  description = "Elastic Beanstalk application for a scalable web app."
}

# Create an application version for Elastic Beanstalk referencing the S3 bundle.
resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = var.app_version_label
  application = aws_elastic_beanstalk_application.web_app.name

  bucket = aws_s3_bucket.app_bucket.id
  key    = aws_s3_bucket_object.app_bundle.key

  lifecycle {
    ignore_changes = [
      bucket,
      key,
    ]
  }
}

# Create the Elastic Beanstalk Environment with Auto Scaling settings.
resource "aws_elastic_beanstalk_environment" "web_app_env" {
  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.web_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.6 running Node.js 14"
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

This updated template utilizes correct attribute references (e.g., using aws_s3_bucket.app_bucket.id) and ensures that the HCL syntax is proper. You can deploy this configuration after ensuring the prerequisite “webapp.zip” file is available.