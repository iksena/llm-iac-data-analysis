terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# S3 Bucket for the application source bundle
resource "aws_s3_bucket" "app_bucket" {
  bucket = "sampleapril26426"
  acl    = "private"
}

# S3 Object representing the application source bundle
resource "aws_s3_object" "app_object" {
  bucket       = aws_s3_bucket.app_bucket.id
  key          = "examplebucket_object"
  content      = "This is a dummy application source bundle for Elastic Beanstalk worker environment."
  content_type = "text/plain"
}

# SQS Queue for Elastic Beanstalk to process jobs
resource "aws_sqs_queue" "batch_job_queue" {
  name = "batch_job_queue"
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "batch_job_app" {
  name        = "batch_job_app"
  description = "Elastic Beanstalk application for batch processing jobs."
}

# Elastic Beanstalk Application Version
resource "aws_elastic_beanstalk_application_version" "version" {
  application   = aws_elastic_beanstalk_application.batch_job_app.name
  version_label = "version"
  bucket        = aws_s3_bucket.app_bucket.id
  key           = aws_s3_object.app_object.key

  lifecycle {
    create_before_destroy = true
  }
}

# IAM Role for EC2 instances used in the Elastic Beanstalk environment
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

# Attach the AWS managed policy for Elastic Beanstalk Worker Tier to the role
resource "aws_iam_role_policy_attachment" "eb_ec2_role_attachment" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

# IAM Instance Profile for EC2 instances in the EB environment
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Elastic Beanstalk Worker Environment for running batch jobs
resource "aws_elastic_beanstalk_environment" "worker_env" {
  name                = "batch_job_worker_env"
  application         = aws_elastic_beanstalk_application.batch_job_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.1.0 running Python"  # Ensure this stack is available

  version_label = aws_elastic_beanstalk_application_version.version.version_label

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "Worker"
  }

  setting {
    namespace = "aws:elasticbeanstalk:sqsd"
    name      = "WorkerQueueURL"
    value     = aws_sqs_queue.batch_job_queue.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
}