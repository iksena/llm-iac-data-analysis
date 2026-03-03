provider "aws" {
  region = "us-east-1"
}

#########################
# IAM Role & Instance Profile for EB
#########################

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

resource "aws_iam_role_policy_attachment" "eb_ec2_role_attachment" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

#########################
# S3 Bucket & Object for Application Version
#########################

resource "aws_s3_bucket" "app_bucket" {
  bucket = "sampleapril26426"
  acl    = "private"

  force_destroy = true
}

resource "aws_s3_object" "app_object" {
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "examplebucket_object"
  content = "This is a dummy deployment package for the application version."
  etag   = md5("This is a dummy deployment package for the application version.")
}

#########################
# Elastic Beanstalk Application & Version
#########################

resource "aws_elastic_beanstalk_application" "myapp" {
  name        = "myapp"
  description = "Elastic Beanstalk Application for myapp"
}

resource "aws_elastic_beanstalk_application_version" "version" {
  name        = "version"
  application = aws_elastic_beanstalk_application.myapp.name

  bucket = aws_s3_bucket.app_bucket.bucket
  key    = aws_s3_object.app_object.key

  description = "Application version based on S3 object examplebucket_object"
  # Ensure a new version is created if the S3 object changes:
  lifecycle {
    create_before_destroy = true
  }
}

#########################
# Elastic Beanstalk Environment
#########################

resource "aws_elastic_beanstalk_environment" "environment" {
  name                = "myapp-env"
  application         = aws_elastic_beanstalk_application.myapp.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"
  version_label       = aws_elastic_beanstalk_application_version.version.name

  setting {
    namespace  = "aws:autoscaling:launchconfiguration"
    name       = "IamInstanceProfile"
    value      = aws_iam_instance_profile.eb_ec2_profile.name
  }

  # Optionally configure environment variables, instance types, etc.
}