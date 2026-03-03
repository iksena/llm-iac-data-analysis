provider "aws" {
  region = "us-east-1"
}

# Create IAM role for EC2 instances
resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"

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

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "eb_worker_tier" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "eb_sqs_access" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

# Create instance profile
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Create S3 bucket
resource "aws_s3_bucket" "application_bucket" {
  bucket = "sampleapril26426"
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.application_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create S3 bucket object
resource "aws_s3_object" "examplebucket_object" {
  bucket = aws_s3_bucket.application_bucket.id
  key    = "beanstalk/application.zip"
  source = "application.zip"  # Make sure this file exists in your local directory
}

# Create SQS queue
resource "aws_sqs_queue" "batch_job_queue" {
  name = "batch_job_queue"
}

# Create Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "batch_job_app" {
  name        = "batch_job_app"
  description = "Batch processing application"
}

# Create Elastic Beanstalk application version
resource "aws_elastic_beanstalk_application_version" "version" {
  name        = "version"
  application = aws_elastic_beanstalk_application.batch_job_app.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.application_bucket.id
  key         = aws_s3_object.examplebucket_object.key
}

# Create Elastic Beanstalk worker environment
resource "aws_elastic_beanstalk_environment" "worker_environment" {
  name                = "worker-environment"
  application         = aws_elastic_beanstalk_application.batch_job_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.5.4 running Docker"
  tier                = "Worker"
  version_label      = aws_elastic_beanstalk_application_version.version.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:sqsd"
    name      = "WorkerQueueURL"
    value     = aws_sqs_queue.batch_job_queue.id
  }

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
}