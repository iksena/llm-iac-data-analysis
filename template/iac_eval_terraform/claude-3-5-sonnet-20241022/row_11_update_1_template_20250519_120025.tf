provider "aws" {
  region = "us-east-1"
}

# Variables
variable "domain_name" {
  description = "Domain name for the Route 53 zone"
  default     = "example.com"
}

# Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# S3 Bucket for Application Version
resource "aws_s3_bucket" "eb_bucket" {
  bucket = "my-unique-eb-bucket-name-12345"
}

resource "aws_s3_bucket_versioning" "eb_bucket_versioning" {
  bucket = aws_s3_bucket.eb_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Sample object in S3 bucket
resource "aws_s3_object" "examplebucket_object" {
  bucket = aws_s3_bucket.eb_bucket.id
  key    = "application-version.zip"
  source = "dummy.zip"  # You need to have this file locally
}

# IAM Role for EC2 instances
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

# Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# Instance Profile
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "myapp" {
  name        = "myapp"
  description = "My Application"
}

# Elastic Beanstalk Application Version
resource "aws_elastic_beanstalk_application_version" "version" {
  name        = "version"
  application = aws_elastic_beanstalk_application.myapp.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.eb_bucket.id
  key         = aws_s3_object.examplebucket_object.key
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "eb-env" {
  name                = "eb-env"
  application         = aws_elastic_beanstalk_application.myapp.name
  solution_stack_name = "64bit Amazon Linux 2 v5.6.4 running Node.js 18"
  version_label      = aws_elastic_beanstalk_application_version.version.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
}

# Route 53 Alias Record
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elastic_beanstalk_environment.eb-env.cname
    zone_id                = "Z117KPS5GTRQ2G"  # This is a fixed value for Elastic Beanstalk in us-east-1
    evaluate_target_health = true
  }
}