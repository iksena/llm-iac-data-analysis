provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "elastic_beanstalk_service_role" {
  name = "elastic_beanstalk_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "elastic_beanstalk_service_policy" {
  name   = "elastic_beanstalk_service_policy"
  role   = aws_iam_role.elastic_beanstalk_service_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "cloudwatch:*",
          "s3:*",
          "sns:*",
          "cloudformation:*",
          "rds:*",
          "sqs:*",
          "elasticbeanstalk:*",
          "logs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_elastic_beanstalk_application" "example" {
  name        = "example-app"
  description = "An example Elastic Beanstalk application"

  appversion_lifecycle {
    service_role          = aws_iam_role.elastic_beanstalk_service_role.arn
    max_age_in_days       = 5
    delete_source_from_s3 = true
  }
}

resource "aws_elastic_beanstalk_application_version" "example" {
  name        = "v1"
  application = aws_elastic_beanstalk_application.example.name
  bucket      = aws_s3_bucket.example.bucket
  key         = aws_s3_bucket_object.example.key
}

resource "aws_s3_bucket" "example" {
  bucket = "example-app-bucket"
}

resource "aws_s3_bucket_object" "example" {
  bucket = aws_s3_bucket.example.bucket
  key    = "example-app-v1.zip"
  source = "path/to/your/application.zip"
}