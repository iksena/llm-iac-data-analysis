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

# S3 Bucket to hold the Elastic Beanstalk application source bundle
resource "aws_s3_bucket" "app_bucket" {
  bucket = "sampleapril26426"
  acl    = "private"
}

# S3 Object representing the application source bundle uploaded to the bucket
resource "aws_s3_object" "app_object" {
  bucket       = aws_s3_bucket.app_bucket.id
  key          = "examplebucket_object"
  content      = "This is a dummy application source bundle for the Elastic Beanstalk worker environment."
  content_type = "text/plain"
}

# SQS Queue for worker jobs
resource "aws_sqs_queue" "batch_job_queue" {
  name = "batch_job_queue"
}

# Elastic Beanstalk Application for batch processing jobs
resource "aws_elastic_beanstalk_application" "batch_job_app" {
  name        = "batch_job_app"
  description = "Elastic Beanstalk application for running batch processing jobs."
}

# Elastic Beanstalk Application Version, referring to the S3 bucket and object.
# The "name" attribute serves as the version label.
resource "aws_elastic_beanstalk_application_version" "version" {
  name        = "version"
  application = aws_elastic_beanstalk_application.batch_job_app.name
  bucket      = aws_s3_bucket.app_bucket.id
  key         = aws_s3_object.app_object.key

  lifecycle {
    create_before_destroy = true
  }
}

# IAM Role for Elastic Beanstalk EC2 instances
resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Attach managed policy for Elastic Beanstalk worker tier to the IAM role
resource "aws_iam_role_policy_attachment" "eb_ec2_role_attachment" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

# IAM Instance Profile for EC2 instances in the environment
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Elastic Beanstalk Worker Environment that utilizes the SQS queue for batch jobs
resource "aws_elastic_beanstalk_environment" "worker_env" {
  name                = "batch_job_worker_env"
  application         = aws_elastic_beanstalk_application.batch_job_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.1.0 running Python"
  version_label       = aws_elastic_beanstalk_application_version.version.name

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