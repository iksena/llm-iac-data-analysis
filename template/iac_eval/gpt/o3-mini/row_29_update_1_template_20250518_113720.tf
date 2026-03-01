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
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Elastic Beanstalk application name"
  type        = string
  default     = "go-beanstalk-app"
}

variable "env_name" {
  description = "Elastic Beanstalk environment name"
  type        = string
  default     = "go-beanstalk-env"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for storing Elastic Beanstalk application artifacts"
  type        = string
  default     = "eb-go-artifacts-bucket-example-terraform"
}

variable "artifact_key" {
  description = "S3 key for the application version artifact"
  type        = string
  default     = "go_app_v1.zip"
}

# S3 Bucket to store the application artifact.
resource "aws_s3_bucket" "beanstalk_artifacts_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "Elastic Beanstalk Artifacts Bucket"
  }
}

# S3 Object representing the Go application artifact.
# This is a placeholder content for a zip file.
resource "aws_s3_bucket_object" "go_app_artifact" {
  bucket  = aws_s3_bucket.beanstalk_artifacts_bucket.bucket
  key     = var.artifact_key
  content = "Placeholder for Go application zip content"
  etag    = md5("Placeholder for Go application zip content")
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "go_app" {
  name        = var.app_name
  description = "Elastic Beanstalk Application running a version of Go"
}

# Elastic Beanstalk Application Version
resource "aws_elastic_beanstalk_application_version" "go_app_version" {
  name        = "v1"
  application = aws_elastic_beanstalk_application.go_app.name
  description = "Version 1 of the Go application"
  bucket      = aws_s3_bucket.beanstalk_artifacts_bucket.bucket
  key         = aws_s3_bucket_object.go_app_artifact.key

  # Make sure the application version is created after artifact upload.
  depends_on = [aws_s3_bucket_object.go_app_artifact]
}

# IAM Role for Elastic Beanstalk Service
resource "aws_iam_role" "beanstalk_service_role" {
  name = "beanstalk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "elasticbeanstalk.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "beanstalk_service_role_attach" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkEnhancedHealth"
}

# IAM Role for EC2 instances in Elastic Beanstalk environment.
resource "aws_iam_role" "beanstalk_ec2_role" {
  name = "beanstalk-ec2-role"

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

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_role_attach" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# Instance Profile for the EC2 role used by Elastic Beanstalk
resource "aws_iam_instance_profile" "beanstalk_instance_profile" {
  name = "beanstalk-instance-profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}

# Elastic Beanstalk Environment with Go platform.
resource "aws_elastic_beanstalk_environment" "go_env" {
  name                = var.env_name
  application         = aws_elastic_beanstalk_application.go_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Go 1"  # Adjust as needed based on available platforms.
  version_label       = aws_elastic_beanstalk_application_version.go_app_version.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service_role.arn
  }

  tags = {
    Environment = "Production"
    Application = var.app_name
  }

  depends_on = [
    aws_elastic_beanstalk_application_version.go_app_version,
    aws_iam_instance_profile.beanstalk_instance_profile,
    aws_iam_role.beanstalk_service_role
  ]
}