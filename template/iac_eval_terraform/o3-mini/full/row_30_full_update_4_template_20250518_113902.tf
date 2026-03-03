Below is an improved version of the Terraform template. In this version, the etag attribute—which was using the filemd5() function on a file that may not exist—is removed. (Before applying this configuration, ensure that the "webapp.zip" file is present in your working directory or adjust the configuration accordingly.) 

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

resource "aws_iam_role" "beanstalk_ec2_role" {
  name = "beanstalk_ec2_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
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

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_policy_attach" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "beanstalk_instance_profile" {
  name = "beanstalk_instance_profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}

#####################
# S3 BUCKET & APPLICATION BUNDLE
#####################

resource "aws_s3_bucket" "app_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  tags = {
    Name = "WebAppBucket"
  }
}

resource "aws_s3_bucket_object" "app_bundle" {
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "webapp.zip"
  source = "webapp.zip"
  # Note: The etag attribute using filemd5() has been removed to avoid errors if the file is missing.
}

#####################
# ELASTIC BEANSTALK RESOURCES
#####################

resource "aws_elastic_beanstalk_application" "web_app" {
  name        = var.app_name
  description = "Elastic Beanstalk application for a scalable web app."
}

resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = var.app_version_label
  application = aws_elastic_beanstalk_application.web_app.name
  bucket      = aws_s3_bucket.app_bucket.bucket
  key         = aws_s3_bucket_object.app_bundle.key

  lifecycle {
    ignore_changes = [
      bucket,
      key
    ]
  }
}

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